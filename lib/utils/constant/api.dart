class ApiKonstant {
  static const baseUrl = "http://10.0.101.135:8000/";
  static const login = "authtoken/login/";
  static const refresh = "authtoken/refresh/";
  static const register = "user/register/";

  static Map refreshToken(String token) {
    return {
      "refresh": token,
    };
  }
}
