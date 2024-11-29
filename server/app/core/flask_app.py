import os;
import importlib;

from dotenv import load_dotenv;

from flask import Flask;
from flask_cors import CORS

from .settings import Settings;
from .mongo_db import MongoDB;
from ..enums.flask_environment_enums import FLASK_ENVIRONMENT_ENUMS;

# End point imports
from ..endpoints.auth_endpoints import AuthEndpoints;
from ..endpoints.recipe_endpoints import RecipeEndpoints;

APPLICATION_PORT = 5000;

class FlaskApp:
  """
  Flask App Class, responsible for loading and initiating the flask app while registering any routing blueprints.
  """
  
  def __init__(self, mongo_db : MongoDB) -> None:
    """
    Initiates and sets up the Flask app

    Parameters
      self : object class instance

    Returns
      None

    Raises
      None
    """
    
    self.flask_app = Flask(__name__);
    CORS(self.flask_app);
    
    # retrieve env variables
    flask_env = Settings.FLASK_ENV;
    flask_secret_key = Settings.FLASK_SECRET_KEY;

    # setting flask configurations
    self.flask_app.config["SECRET_KEY"] = flask_secret_key;

    # config debug_mode based on flask_env
    if flask_env == FLASK_ENVIRONMENT_ENUMS.DEVELOPMENT.value:
      self.flask_app.config["DEBUG"] = True;
    else:
      self.flask_app.config["DEBUG"] = False;
   
    # append all blue print creation callbacks and iterate and create and register
    blueprint_callbacks = [];    
  
    blueprint_callbacks.append(AuthEndpoints.main);
    blueprint_callbacks.append(RecipeEndpoints.main);
    
    for callback in blueprint_callbacks:
      blueprint = callback(self.flask_app, mongo_db);
      self.flask_app.register_blueprint(blueprint);
    
    # set up event triggers
    @self.flask_app.before_request
    def _before_request():
      """
      Runs before an API request, opens a connection with MongoDB.

      Parameters
        self : object class instance

      Returns
        None

      Raises
        None
      """
      mongo_db.establishConnection();
        
    # after request: close the database connection (always called)
    @self.flask_app.teardown_appcontext
    def _shutdown_session(exception=None):
      """
      Runs after API call, closes any existing connection with MongoDB.

      Parameters
        self : object class instance

      Returns
        None

      Raises
        None
      """
      if exception:
        print(f"An error occurred: {exception}")
      mongo_db.closeConnection();
        
    # attach the database to the flask app
    self.flask_app.mongo_db = mongo_db;
    self.flask_app.run(port=APPLICATION_PORT);