from enum import Enum;

class API_ERROR_ENUMS(Enum):
  """
  Enums for API error messages.
  """
  DATA_NOT_JSON = "DATA NOT JSON";
  DATABASE_ERROR = "AN ERROR HAS OCCURED IN THE DATABASE";
  INTERNAL_SERVER_ERROR = "AN UNEXPECTED ERROR HAS OCCURED";
  
  MISSING_FIELDS = "THERE ARE MISSING FIELDS TO YOUR REQUEST";
  USERNAME_DOES_NOT_EXIST = "USERNAME DOES NOT EXIST";
  INCORRECT_LOGIN_INFORMATION = "INCORRECT LOGIN INFORMATION";
  INVALID_USERNAME = "INVALID USERNAME";
  INVALID_EMAIL = "INVALID EMAIL"
  INVALID_PASSWORD = "INVALID PASSWORD";
  USERNAME_TAKEN = "USERNAME IS TAKEN";
  EMAIL_TAKEN = "EMAIL IS ALREADY IN USE";