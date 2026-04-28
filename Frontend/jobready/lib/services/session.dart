class Session {
  static String? token;
  static String? role;

  static void logout() {
    token = null;
    role = null;
  }
}