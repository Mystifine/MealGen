import jwt;

from datetime import datetime, timedelta;

from ..core.settings import Settings;

class JWTAuthentication:
  """
  JWTAuthentication class for authentication functions
  """
    
  @staticmethod
  def generateAuthenticationToken(user_id : str) -> str:
    """
    generates and returns an authentication code provided a userid.
    
    Parameters:
      user_id
      
    Returns:
      str: The authentication generated code
    """
    jwt_secret_key = Settings.JWT_SECRET_KEY;
    
    payload = {
      "user_id" : user_id,
      "exp": datetime.now() + timedelta(hours=10)
    }
    
    authentication_token = jwt.encode(payload, jwt_secret_key, algorithm='HS256');
    return authentication_token;
    
  @staticmethod
  def validateAuthenticationToken(token : str) -> dict[str : str] | str:
    """
    Validates authentication token
    
    Args:
      token (str): The token to be authenticated

    Returns:
      dict[str : str] | str: The payload of the token or an error message.
    """
    
    jwt_secret_key = Settings.JWT_SECRET_KEY;
    
    try:
      payload = jwt.decode(token, jwt_secret_key, algorithms=["HS256"]);
      return payload;  
    except jwt.ExpiredSignatureError:
      return "Token has expired";
    except jwt.InvalidTokenError:
      return "Invalid token";