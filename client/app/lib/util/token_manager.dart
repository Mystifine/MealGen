class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  
  String? _authenticationToken;

  TokenManager._internal();

  factory TokenManager() => _instance;

  // Getter 
  String? get authToken => _authenticationToken;

  // Setter
  set authToken(String? token) {
    _authenticationToken = token;
  }
}