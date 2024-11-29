class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  
  String? authenticationToken;

  TokenManager._internal();

  factory TokenManager() => _instance;
}