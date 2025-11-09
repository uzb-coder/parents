import 'package:flutter/material.dart';
import 'package:parents/src/services/debts/debts_service.dart';
import '../model/payment/PaymentsModel.dart';
import '../model/debts/DebtModel.dart';
import '../services/payment/PaymentsService.dart';

class PaymentsProvider with ChangeNotifier {
  PaymentsResponse? _payments;
  DebtResponse? _debts;
  bool _isLoading = false;

  PaymentsResponse? get payments => _payments;
  DebtResponse? get debts => _debts;
  bool get isLoading => _isLoading;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // To'lovlar ma'lumotlarini olish
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

  // Qarzdorlik ma'lumotlarini olish
  Future<void> fetchDebts() async {
    try {
      final result = await DebtsService.fetchDebts();
      _debts = result;
      notifyListeners();
    } catch (e) {
      print("Error fetching debts: $e");
    }
  }

  // Ikkala ma'lumotni birga olish
  Future<void> fetchAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        PaymentsService.fetchPayments().then((value) => _payments = value),
        DebtsService.fetchDebts().then((value) => _debts = value),
      ]);
    } catch (e) {
      print("Error fetching all data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===== TO'LOVLAR UCHUN GETTERS =====

  // Umumiy balans (barcha o'quvchilar)
  int get totalBalance {
    if (_payments == null) return 0;
    return _payments!.data.fold(
      0,
      (sum, item) => sum + (item.summary.remainingDebt),
    );
  }

  // Tanlangan o'quvchining to'langan summasi
  int get selectedStudentTotalPaid {
    if (_payments == null || _payments!.data.isEmpty) return 0;
    if (_selectedIndex >= _payments!.data.length) return 0;
    return _payments!.data[_selectedIndex].payments.fold(
      0,
      (sum, p) => sum + p.amount,
    );
  }

  // Tanlangan o'quvchining qolgan qarzi (to'lovlar asosida)
  int get selectedStudentRemainingDebt {
    if (_payments == null || _payments!.data.isEmpty) return 0;
    if (_selectedIndex >= _payments!.data.length) return 0;
    return _payments!.data[_selectedIndex].summary.remainingDebt;
  }

  // ===== QARZDORLIK UCHUN GETTERS =====

  // Tanlangan o'quvchining umumiy qarzdorligi
  int get selectedStudentTotalDebt {
    if (_debts == null || _debts!.data.isEmpty) return 0;
    if (_selectedIndex >= _debts!.data.length) return 0;
    return _debts!.data[_selectedIndex].totalDebt;
  }

  // Tanlangan o'quvchining qarzdorlik ma'lumotlari
  DebtData? get selectedStudentDebtData {
    if (_debts == null || _debts!.data.isEmpty) return null;
    if (_selectedIndex >= _debts!.data.length) return null;
    return _debts!.data[_selectedIndex];
  }

  // Tanlangan o'quvchining qarzdorlik oylari soni
  int get selectedStudentDebtMonthsCount {
    if (_debts == null || _debts!.data.isEmpty) return 0;
    if (_selectedIndex >= _debts!.data.length) return 0;
    return _debts!.data[_selectedIndex].debtMonthsCount;
  }

  // Tanlangan o'quvchining oylik to'lovi
  int get selectedStudentMonthlyFee {
    if (_debts == null || _debts!.data.isEmpty) return 0;
    if (_selectedIndex >= _debts!.data.length) return 0;
    return _debts!.data[_selectedIndex].monthlyFee;
  }
}
