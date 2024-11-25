from dotenv import load_dotenv;
from os import getenv;

from flask import Flask;

from .core.flask_app import FlaskApp;
from .core.mongo_db import MongoDB;
from .core.settings import Settings;

class App:
    """
    Main server app that handles the initiation of all processes
    
    Attributes:
        flask_app (Flask) : Flask app
        mongo_db (MongoDB) : Database for the application
    """
    
    flask_app : Flask;
    mongo_db : MongoDB;
        
    def __init__(self) -> None:
        """
        Starts the server application. Calls other core initiation functions.
        
        Parameters
            self : object class instance

        Returns
            None

        Raises
            None
        """
        
        # load settings first for the application
        Settings.loadSettings();
        
        # initializes the mongo database class
        self.mongo_db = MongoDB();

        # initializes the API end points by starting flask
        self.flask_app = FlaskApp(self.mongo_db);