import 'package:dio/dio.dart';
import 'package:parents/global/api_global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/LessonsModel.dart';

class TodayLessonsService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiGlobal.baseUrl),
  );

  // Tokenni olish
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token;
  }

  static Future<TodayLessonsResponse?> fetchTodayLessons() async {
    try {
      final token = await getToken();
      if (token == null) {
        return null;
      }

      final response = await _dio.get(
        '/parents/today-lessons',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return TodayLessonsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      return null;
    }
  }
}
