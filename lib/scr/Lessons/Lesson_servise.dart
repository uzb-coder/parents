import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/LessonsModel.dart';

class TodayLessonsService {
  static final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://7f661wm9-8030.euw.devtunnels.ms/api"),
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
      print('API Response Data: ${response.data}');

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
