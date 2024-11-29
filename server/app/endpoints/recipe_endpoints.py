import bcrypt;
import traceback;
import datetime;

from pymongo.errors import PyMongoError;
from bson import ObjectId;
from flask import Flask, Blueprint, jsonify, request;

from ..core.mongo_db import MongoDB;

from ..util.generate_authentication_code import JWTAuthentication;
from ..util.user_input_validation import UserInputValidation;

from ..enums.api_error_enums import API_ERROR_ENUMS;
from ..enums.http_codes_enums import HTTP_CODE_ENUMS;

class RecipeEndpoints:
  """
  Recipe end points for recipe related requests
  """
  @staticmethod
  def main(flask_app : Flask, mongo_db : MongoDB) -> Blueprint:
    auth_blueprint = Blueprint('recipe', __name__, url_prefix='/recipe');
    
    @auth_blueprint.route('/upload', methods=['POST'])
    def upload():
      if not request.is_json:
        return jsonify({'error': API_ERROR_ENUMS.DATA_NOT_JSON.value}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

      # Set return data and return it to the client.
      return_data = {};

      try:
        # Retrieve data from request, retrieved data is a python dictionary.
        data = request.get_json();
        
        # The expected data we will be receiving.
        recipe_title = data['title'];
        recipe_description = data['description'];
        recipe_image_bytes = data['image_bytes'];
        client_authentication_token = data['authentication_token'];
        
        if not (recipe_title or recipe_description or recipe_image_bytes or client_authentication_token):
          return_data['error'] = API_ERROR_ENUMS.MISSING_FIELDS.value;
          return jsonify(return_data), HTTP_CODE_ENUMS.BAD_REQUEST.value;
        
        # We want to see if the authentication_token is valid or not.
        # If it is not valid we will tell the client to log out
        # If it is valid we will process the request
        
        auth_code, auth_result = JWTAuthentication.validateAuthenticationToken(client_authentication_token);
        if (auth_code == 0):
          return_data['error'] = API_ERROR_ENUMS.UNAUTHORIZED_REQUEST.value;
          return jsonify(return_data), HTTP_CODE_ENUMS.UNAUTHORIZED.value;
        
        user_id = auth_result['user_id'];
        users_collection = mongo_db.database["users"];

        query_result = users_collection.find_one({
          '_id' : ObjectId(user_id),
          "authentication_token": client_authentication_token
        });

        # If we can't find an entry then this authentication_token is not valid
        if query_result is None:
          return_data['error'] = API_ERROR_ENUMS.UNAUTHORIZED_REQUEST.value;
          return jsonify(return_data), HTTP_CODE_ENUMS.UNAUTHORIZED.value;
        
        # All is good at this point, we now want to add to recipes data
        document = {
          'title' : recipe_title,
          'description' : recipe_description,
          'image_bytes' : recipe_image_bytes,
          'author' : user_id,
          'publish_date' : datetime.datetime.now(datetime.timezone.utc)
        };
        
        recipes_collection = mongo_db.database['recipes'];
        recipes_collection.insert_one(document);
        
        return jsonify(return_data), HTTP_CODE_ENUMS.CREATED.value;
      except PyMongoError as err:
        # if the validation fails, return the errors
        print(f"An error has occured: {err}");
        return_data['error'] = API_ERROR_ENUMS.DATABASE_ERROR.value
        return jsonify(return_data), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value
      except Exception as err:
        # if the validation fails, return the errors
        print(f"An error has occured: {err}");
        traceback.print_exc();
        return_data['error'] = API_ERROR_ENUMS.INTERNAL_SERVER_ERROR.value
        return jsonify(return_data), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value

    @auth_blueprint.route('/signup', methods=['POST'])
    def signup():
      if not request.is_json:
        return jsonify({'error': API_ERROR_ENUMS.DATA_NOT_JSON.value}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

      try:
        # Retrieve data from request, retrieved data is a python dictionary.
        data = request.get_json();
        
        username = data['username'];
        email = data['email'];
        password = data['password'];
        
        # First, make sure that these are valid inputs before proceeding.
        if not UserInputValidation.validate_username(username):
          return jsonify({'error': API_ERROR_ENUMS.INVALID_USERNAME.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        if not UserInputValidation.validate_email(email):
          return jsonify({'error': API_ERROR_ENUMS.INVALID_EMAIL.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        if not UserInputValidation.validate_password(password):
          return jsonify({'error': API_ERROR_ENUMS.INVALID_PASSWORD.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        
        users_collection = mongo_db.database["users"];
        
        # We want to query the username to ensure that the username has not already been taken.
        username_result = users_collection.find_one({"username" : username});
        
        # If we got a result that means that the username is already taken.
        if username_result:
          return jsonify({'error': API_ERROR_ENUMS.USERNAME_TAKEN.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        
        # If we get this far, we are valid to create a new account. We will start the hashing process.
        salt = bcrypt.gensalt();
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt).decode('utf-8');
        
        # Now we want to try to write to database;
        document_data = {
          'email' : email,
          'username' : username,
          'password' : hashed_password,
        }

        insert_result = users_collection.insert_one(document_data);
        
        # After MongoDB automatically generates an _id field we will use that to generate a AuthenticationToken.
        # We will save the active authentication token to the database and use that to find the user.
        user_id = str(insert_result.inserted_id);
        authentication_token = JWTAuthentication.generateAuthenticationToken(user_id);

        users_collection.update_one(
          {'username' : username}, 
          {'$set' : {'authentication_token' : authentication_token,}}
        );
        
        # Set return data and return it to the client.
        return_data = {
          'authentication_token' : authentication_token,
        };
        
        return jsonify(return_data), HTTP_CODE_ENUMS.CREATED.value;
      except PyMongoError as err:
        # if the validation fails, return the errors
        print(f"An error has occured: {err}");
        return jsonify({'error': API_ERROR_ENUMS.DATABASE_ERROR.value}), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value
      except Exception as err:
        # if the validation fails, return the errors
        print(f"An error has occured: {err}");
        return jsonify({'error': API_ERROR_ENUMS.INTERNAL_SERVER_ERROR.value}), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value


    return auth_blueprint;