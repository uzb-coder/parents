import 'package:parents/library/librarys.dart';
import '../../../model/GradeModel.dart';

class GradeService {
  static final Dio _dio = Dio();

  // Tokenni olish
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Baholarni olish
  static Future<GradesResponse?> fetchGrades(String childId) async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final url = '${ApiGlobal.baseUrl}/parents/grades/$childId';

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return GradesResponse.fromJson(response.data);
      } else {
        print('Server returned status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error fetching grades: $e");
      return null;
    }
  }
}

