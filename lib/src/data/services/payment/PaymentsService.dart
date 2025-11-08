import 'package:parents/src/library/librarys.dart';
import '../../model/PaymentsModel.dart';

class PaymentsService {
  static final Dio _dio = Dio();

  // Tokenni olish
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<PaymentsResponse?> fetchPayments() async {
    try {
      final token = await getToken();
      if (token == null) {
        return null;
      }

      final url = "${ApiGlobal.baseUrl}/payments";

      final response = await _dio.get(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PaymentsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching payments: $e");
      return null;
    }
  }
}
