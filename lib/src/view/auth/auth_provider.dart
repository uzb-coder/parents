import 'package:flutter/foundation.dart';
import 'package:parents/src/data/model/loginModel.dart';
import 'package:parents/src/data/services/auth/login_service.dart';

class AuthProvider with ChangeNotifier {
  Parents? _parents;
  bool _loading = false;

  Parents? get parents => _parents;
  bool get loading => _loading;

  // Login qilish
  Future<void> login(String phone) async {
    _loading = true;
    notifyListeners();

    Parents? result = await LoginService.loginUser(phone);
    if (result != null) {
      _parents = result;
    }

    _loading = false;
    notifyListeners();
  }

  // Saqlangan ma’lumotni yuklash
  Future<void> loadSavedParents() async {
    _parents = await LoginService.getSavedParents();
    notifyListeners();
  }
}
