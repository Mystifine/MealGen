

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  
  String? authenticationToken;
  String? username;
  String? password;
  String? userid;

  SessionManager._internal();

  factory SessionManager() => _instance;
}