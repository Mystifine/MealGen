import bcrypt;

from pymongo.errors import PyMongoError;
from flask import Flask, Blueprint, jsonify, request;
from ..core.mongo_db import MongoDB;

from ..enums.api_error_enums import API_ERROR_ENUMS;
from ..enums.http_codes_enums import HTTP_CODE_ENUMS;

class AuthEndpoints:
  """
  Authentication end points initiation.
  """
  
  @staticmethod
  def main(flask_app : Flask, mongo_db : MongoDB) -> Blueprint:
    auth_blueprint = Blueprint('auth', __name__, url_prefix='/auth');
    
    @auth_blueprint.route('/login', methods=['POST'])
    def login():
      if not request.is_json:
        return jsonify({'error': API_ERROR_ENUMS.DATA_NOT_JSON.value}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

      try:
        # validate and deserialize the JSON data using the schema
        data = request.get_json();
        
        # now we want to check if this user exists in the database using either username or email
        collection = mongo_db["users"];
        result = collection.find_one({
          "$or": [ 
              {"username" : data['username']}, 
              {"email" : data['email']} 
            ]
          }
        );

        if result is None:
          return jsonify({'error': API_ERROR_ENUMS.USERNAME_TAKEN.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        
        # if the result is not none we need to now compare the password;
        if not bcrypt.checkpw(data['password'].encode('utf-8'), result['password'].encode('utf-8')):
          return jsonify({'error': API_ERROR_ENUMS.INVALID_PASSWORD.value}), HTTP_CODE_ENUMS.UNAUTHORIZED.value;

        # If we got here that means they successfully logged in!
        return jsonify(result), HTTP_CODE_ENUMS.OK.value;
        
      except Exception as err:
        # if the validation fails, return the errors
        return jsonify({"errors": err.messages}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

    @auth_blueprint.route('/signup', methods=['POST'])
    def signup():
      if not request.is_json:
        return jsonify({'error': API_ERROR_ENUMS.DATA_NOT_JSON.value}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

      try:
        # validate and deserialize the JSON data using the schema
        data = request.get_json();
        
        # now we want to check if this user exists in the database using either username or email
        collection = mongo_db.database["users"];
        
        username_result = collection.find_one({"username" : data['username']});
        email_result = collection.find_one({'email' : data["email"]});
        
        if username_result:
          return jsonify({'error': API_ERROR_ENUMS.USERNAME_TAKEN.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        
        if email_result:
          return jsonify({'error': API_ERROR_ENUMS.EMAIL_TAKEN.value}), HTTP_CODE_ENUMS.INTERNAL_CONFLICT.value;
        
        salt = bcrypt.gensalt();
        hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), salt).decode('utf-8');
        
        # Now we want to try to write to database;
        try:
          document_data = {
            "email" : data['email'],
            "username" : data['username'],
            "password" : hashed_password,
            "stars" : 0,
          };
          
          validated_data = document_data;
          
          collection = mongo_db["users"];
          result = collection.insert_one(validated_data);
          
          inserted_user = collection.find_one({"_id": result.inserted_id})
          
          return jsonify(inserted_user), HTTP_CODE_ENUMS.CREATED.value
        except PyMongoError as e:
          return jsonify({"error": e}), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value;
        
      except Exception as err:
        # if the validation fails, return the errors
        return jsonify({"errors": err.messages}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

    return auth_blueprint;