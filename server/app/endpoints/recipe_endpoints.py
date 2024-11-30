import traceback;
import datetime;
import time;

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
          'author' : ObjectId(user_id),
          'publish_time' : int(time.time()),
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

    @auth_blueprint.route('/get/<user_id>/<int:page>/<int:page_size>/<sort_option>', methods=['GET'])
    def getRecipes(user_id : str, page : int, page_size : int, sort_option : str):
      if not request.is_json:
        return jsonify({'error': API_ERROR_ENUMS.DATA_NOT_JSON.value}), HTTP_CODE_ENUMS.BAD_REQUEST.value;

      try:
        # Retrieval of recipes does not require the user to be logged in.
        
        recipes_collection = mongo_db.database['recipes'];
        
        # sort settings for each sort option
        sort_fields = {
          'likes' : {'likes_count' : -1},
          'publish_time' : {'publish_time' : -1}
        };
        
        # get the sorting data or default it
        sort_field = sort_fields.get(sort_option, {'likes_count':-1});
        
        query_data = [
          {
            '$lookup' : {
              'from' : 'likes', # The collection to look from
              'localField' : '_id', # The field to match in recipes
              'foreignField' : 'recipe_id', # the field to match in likes
              'as' : 'likes', # name of new attribute
            }
          },
          {
            '$addFields' : {
              'likes_count' : {'$size' : '$likes'}, # count the number of likes
              'is_liked': {
                # conditional 
                '$cond': {
                    'if': {
                      '$in': [
                        user_id, 
                        {
                          '$map': {
                            'input': '$likes', 
                            'as': 'like', 
                            'in': '$$like.user_id'
                          }
                        }
                      ]
                    },
                    'then': True,
                    'else': False,
                }
              }
            }
          },
          {
            '$project' : {
              '_id' : 1,
              'title' : 1,
              'description' : 1,
              'image_bytes' : 1,
              'likes_count' : 1,
              'publish_time' : 1,
            } # what to include in the final combination
          },
          {
            '$sort' : sort_field,
          },
          {
            '$skip' : (page - 1) * page_size # Pagination allows us to get what we need
          },
          {
            '$limit' : page_size # limits how much we get back
          }
        ]
        
        # retrieve the recipes and convert the recipe id to a string so it can be serialized
        recipes = recipes_collection.aggregate(query_data);
        
        # Convert _id to string
        formatted_results = []
        for recipe in recipes:
          recipe['_id'] = str(recipe['_id'])
          formatted_results.append(recipe)

        return jsonify(formatted_results), HTTP_CODE_ENUMS.OK.value;
      except PyMongoError as err:
        # if the validation fails, return the errors
        print(f"An error has occured: {err}");
        return jsonify({'error': API_ERROR_ENUMS.DATABASE_ERROR.value}), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value
      except Exception as err:
        # if the validation fails, return the errors
        print(f"An error has occured: {err}");
        return jsonify({'error': API_ERROR_ENUMS.INTERNAL_SERVER_ERROR.value}), HTTP_CODE_ENUMS.INTERNAL_SERVER_ERROR.value


    return auth_blueprint;