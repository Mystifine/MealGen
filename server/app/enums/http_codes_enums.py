from enum import Enum;

class HTTP_CODE_ENUMS(Enum):
  """
  HTTP return code enums.
  """
  OK = 200;
  CREATED = 201;
  
  BAD_REQUEST = 400;
  INTERNAL_CONFLICT = 409;
  
  UNAUTHORIZED = 401;
  INTERNAL_SERVER_ERROR = 500;