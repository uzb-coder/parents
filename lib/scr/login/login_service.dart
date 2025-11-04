import 'package:parents/library/librarys.dart';

class LoginService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiGlobal.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<Parents?> loginUser(String phone) async {
    try {
      final response = await _dio.post(
        Apiendpoints.login,
        data: {"guardianPhoneNumber": phone},
      );
      if (response.statusCode == 200 && response.data['token'] != null) {
        Parents parents = Parents.fromJson(response.data);
        await _saveToken(parents.token);
        await _saveParents(parents);

        return parents;
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

  // Authorized POST
  static Future<Response?> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await getToken();
      return await _dio.post(
        path,
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      print("POST xatosi: $e");
      return null;
    }
  }

  // Token saqlash
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Token olish
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Tokenni tozalash
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('parents_data');
  }

  // Login qilinganmi?
  static Future<bool> isLoggedIn() async {
    return (await getToken()) != null;
  }

  // Parents ma'lumotini saqlash
  static Future<void> _saveParents(Parents parents) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parents_data', jsonEncode(parents.toJson()));
  }

  // Saqlangan Parents ma'lumotini olish
  static Future<Parents?> getSavedParents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('parents_data');
    if (data != null) {
      return Parents.fromJson(jsonDecode(data));
    }
    return null;
  }

  // Logout qilish
  static Future<void> logout() async {
    await clearToken();
  }
}
