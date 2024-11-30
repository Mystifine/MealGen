import jwt;

from datetime import datetime, timezone, timedelta;

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
      "iat" : datetime.now(timezone.utc),
      "exp": datetime.now(timezone.utc) + timedelta(hours=10)
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
      int: 1 if successful 0 if failed.
      dict[str : str] | str: The payload of the token or an error message.
    """
    
    jwt_secret_key = Settings.JWT_SECRET_KEY;
    
    try:
      payload = jwt.decode(
        token, 
        jwt_secret_key, 
        options={"verify_exp": True},
        algorithms=["HS256"]
      );
      return 1, payload;  
    except jwt.ExpiredSignatureError:
      return 0, "Token has expired";
    except jwt.InvalidTokenError:
      return 0, "Invalid token";