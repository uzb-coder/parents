import 'package:parents/library/librarys.dart';

class HomeService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiGlobal.baseUrl));

  static final api = ApiGlobal.baseUrl;

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token;
  }

  static Future<StudentProgress?> fetchTodayLessons(String studentId) async {
    try {
      final token = await getToken();
      if (token == null) {
        return null;
      }

      final response = await _dio.get(
        '$api/parents/overview/$studentId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return StudentProgress.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
