import 'package:parents/src/library/librarys.dart';
import 'package:parents/src/data/model/lesson/LessonsModel.dart';

class TodayLessonsService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: ApiGlobal.baseUrl));

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token;
  }

  static Future<HomeworkResponse?> fetchTodayLessons() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await _dio.get(
        '/today-lessons',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return HomeworkResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching lessons: $e");
      return null;
    }
  }
}
