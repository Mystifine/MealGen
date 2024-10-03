from .api_endpoints import APIEndPoints;
from .database import Database;

class Main:
    api_endpoints : APIEndPoints;
    database : Database;

    """
    Purpose is to set up the server
    * REST End Points to handle API requests
    * MongoDB
    """
    def __init__(self) -> None:
        self.database = Database();
        self.database.main();
        
        # the api_endpoints depend on the database;
        self.api_endpoints = APIEndPoints();
        self.api_endpoints.main(self.database);
            
        self.api_endpoints.app.run(port=5000);