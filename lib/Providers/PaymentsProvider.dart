import 'package:parents/library/librarys.dart';
import '../model/PaymentsModel.dart';
import '../scr/menu/Service/PaymentsService.dart';


class PaymentsProvider with ChangeNotifier {
  PaymentsResponse? _payments;
  bool _isLoading = false;

  PaymentsResponse? get payments => _payments;
  bool get isLoading => _isLoading;

  Future<void> fetchPayments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await PaymentsService.fetchPayments();
      _payments = result;
    } catch (e) {
      print("Error fetching payments: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  int get totalBalance {
    if (_payments == null) return 0;
    return _payments!.data.fold(
      0,
          (sum, item) =>
      sum + (item.summary.remainingDebt ?? 0),
    );
  }

}
