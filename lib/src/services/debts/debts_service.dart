import 'package:parents/src/data/model/debts/DebtModel.dart';
import 'package:parents/src/library/librarys.dart';

class DebtsService {
  static final Dio _dio = Dio();

  // Token olish
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // ✅ Qarzdorlik ma'lumotlarini olish
  static Future<DebtResponse?> fetchDebts() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final url = '${ApiGlobal.baseUrl}/debts';

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        print(response.data);
        return DebtResponse.fromJson(response.data);
      } else {
        print('Server returned status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("Error fetching debts: $e");
      return null;
    }
  }
}
