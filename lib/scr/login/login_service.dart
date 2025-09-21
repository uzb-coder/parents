import '../../library/librarys.dart';

class LoginService {

  static const String _baseUrl = ApiGlobal.baseUrl;

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  //Login qilish
  static Future<Parents?> loginUser(String phone) async {
    try {
      final response = await _dio.post(
        "$_baseUrl/parents/login",
        data: {"guardianPhoneNumber": phone},
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        // Tokenni saqlaymiz
        await _saveToken(response.data['token']);

        // Student obyektini qaytaramiz (saqlamaymiz)
        if (response.data['student'] != null) {
          return Parents.fromJson(response.data);
        }
      }

      if (response.statusCode == 401) {
        print('Login xato: 401 Unauthorized');
        return null;
      }
      return null;
    } catch (e) {
      print("Login xatosi: $e");
      return null;
    }
  }

  //Token saqlash
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Token olish
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  //Tokenni tozalash
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Login qilinganmi?
  static Future<bool> isLoggedIn() async {
    return (await getToken()) != null;
  }

  //Authorized POST
  static Future<Response?> post(String path) async {
    try {
      final token = await getToken();
      return await _dio.post(
        path,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      print("POST xatosi: $e");
      return null;
    }
  }
}
