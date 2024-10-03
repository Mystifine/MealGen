from flask import Flask, jsonify, request;
from dotenv import load_dotenv;
from marshmallow import ValidationError;

import pymongo;
import pymongo.database;
from pymongo.server_api import ServerApi;
from pymongo.errors import PyMongoError;

import os;
import bcrypt;

from .database import Database;
from .enums import *;
from .schemas import *;

user_schema = UserSchema();
user_client_schema = UserClientSchema();
user_login_schema = UserLoginSchema();
user_sign_up_schema = UserSignUpSchema();

class APIEndPoints:
    app : Flask;
    database_client : pymongo.MongoClient | None;
    database : pymongo.database.Database | None;

    """
    Creates the flask app to be used.
    """
    def __init__(self) -> None:
        self.app = Flask(__name__);
        
        # load the env variables
        load_dotenv("server/app/.env");
        
        # retrieve env variables
        flask_env = os.getenv("FLASK_ENV");
        secret_key = os.getenv("SECRET_KEY");
        
        # setting flask configurations
        self.app.config["SECRET_KEY"] = secret_key;
        
        # config debug_mode based on flask_env
        if flask_env == FLASK_ENVIRONMENT_ENUMS.DEVELOPMENT.value:
            self.app.config["DEBUG"] = True;
        else:
            self.app.config["DEBUG"] = False;

    """
    Main handles the setup of end points
    """
    def main(self, database : Database):
        # before request; open a connection
        @self.app.before_request
        def _before_request():
            self.database_client = pymongo.MongoClient(database.database_url, server_api=ServerApi('1'));
            self.database = self.database_client["MealGen"];

        # after request: close the database connection (always called)
        @self.app.teardown_appcontext
        def _shutdown_session(exception=None):
            if exception:
                print(f"An error occurred: {exception}")
            self.database_client.close()
            self.database_client = None;
            self.database = None;
        
        # attempting to login;
        @self.app.route('/api/users/login', methods=['POST'])
        def _login():
            if not request.is_json:
                return jsonify({'error': API_ERRORS.DATA_NOT_JSON.value}), HTTP_RETURN_CODES.BAD_REQUEST.value;

            try:
                # validate and deserialize the JSON data using the schema
                data = user_login_schema.load(request.get_json());
                
                # now we want to check if this user exists in the database using either username or email
                collection = self.database["users"];
                result = collection.find_one({
                    "$or": [ 
                            {"username" : data['username']}, 
                            {"email" : data['email']} 
                        ]
                    }
                );

                if result is None:
                    return jsonify({'error': API_ERRORS.USERNAME_TAKEN.value}), HTTP_RETURN_CODES.INTERNAL_CONFLICT.value;
                
                # if the result is not none we need to now compare the password;
                if not bcrypt.checkpw(data['password'].encode('utf-8'), result['password'].encode('utf-8')):
                    return jsonify({'error': API_ERRORS.INVALID_PASSWORD.value}), HTTP_RETURN_CODES.UNAUTHORIZED.value;

                # If we got here that means they successfully logged in!
                return jsonify(user_client_schema.dump(result)), HTTP_RETURN_CODES.OK.value;
                
            except ValidationError as err:
                # if the validation fails, return the errors
                return jsonify({"errors": err.messages}), HTTP_RETURN_CODES.BAD_REQUEST.value;
            
        # handle signing up
        @self.app.route('/api/users/sign-up', methods=['POST'])
        def _signUp():
            if not request.is_json:
                return jsonify({'error': API_ERRORS.DATA_NOT_JSON.value}), HTTP_RETURN_CODES.BAD_REQUEST.value;

            try:
                # validate and deserialize the JSON data using the schema
                data = user_sign_up_schema.load(request.get_json());
                
                # now we want to check if this user exists in the database using either username or email
                collection = self.database["users"];
                
                username_result = collection.find_one({"username" : data['username']});
                email_result = collection.find_one({'email' : data["email"]});
                
                if username_result:
                    return jsonify({'error': API_ERRORS.USERNAME_TAKEN.value}), HTTP_RETURN_CODES.INTERNAL_CONFLICT.value;
                
                if email_result:
                    return jsonify({'error': API_ERRORS.EMAIL_TAKEN.value}), HTTP_RETURN_CODES.INTERNAL_CONFLICT.value;
                
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
                    
                    validated_data = user_schema.load(document_data);
                    
                    collection = self.database["users"];
                    result = collection.insert_one(validated_data);
                    
                    inserted_user = collection.find_one({"_id": result.inserted_id})
                    
                    return jsonify(user_client_schema.dump(inserted_user)), HTTP_RETURN_CODES.CREATED.value
                except PyMongoError as e:
                    return jsonify({"error": e}), HTTP_RETURN_CODES.INTERNAL_SERVER_ERROR.value;
                
            except ValidationError as err:
                # if the validation fails, return the errors
                return jsonify({"errors": err.messages}), HTTP_RETURN_CODES.BAD_REQUEST.value;
            
                
    
    