from api_endpoints import APIEndPoints;

class Main:
    api_endpoints : APIEndPoints;

    """
    Purpose is to set up the server
    * REST End Points to handle API requests
    * MongoDB
    """
    def __init__(self) -> None:
        self.api_endpoints = APIEndPoints();

Main();
