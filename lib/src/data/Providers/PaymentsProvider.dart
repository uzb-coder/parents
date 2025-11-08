import 'package:parents/src/library/librarys.dart';
import '../model/PaymentsModel.dart';
import '../services/payment/PaymentsService.dart';

class PaymentsProvider with ChangeNotifier {
  PaymentsResponse? _payments;
  bool _isLoading = false;

  PaymentsResponse? get payments => _payments;
  bool get isLoading => _isLoading;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

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
      (sum, item) => sum + (item.summary.remainingDebt),
    );
  }

  int get selectedStudentTotalPaid {
    if (_payments == null || _payments!.data.isEmpty) return 0;
    return _payments!.data[_selectedIndex].payments.fold(
      0,
      (sum, p) => sum + p.amount,
    );
  }

  int get selectedStudentRemainingDebt {
    if (_payments == null || _payments!.data.isEmpty) return 0;
    return _payments!.data[_selectedIndex].summary.remainingDebt;
  }
}
