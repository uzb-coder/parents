import 'package:parents/src/data/model/grade/gradeModel.dart';
import 'package:parents/src/data/services/grade/GradeService.dart';
import 'package:parents/src/library/librarys.dart';

class GradesProvider extends ChangeNotifier {
  List<Grade> allGrades = [];
  List<Grade> _grades = [];
  bool _isLoading = false;

  DateTime selectedDate = DateTime.now();

  List<Grade> get grades => _grades;
  bool get isLoading => _isLoading;

  /// Ma'lumotlarni yuklash (refresh qo‘llab-quvvatlanadi)
  Future<void> loadGrades({bool refresh = false}) async {
    // Agar refresh bo'lmasa va ma'lumot allaqachon bo'lsa – qayta yuklamaslik
    if (!refresh && allGrades.isNotEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final parents = await LoginService.getSavedParents();
      if (parents == null || parents.children.isEmpty) {
        allGrades = [];
        _grades = [];
        return _finishLoading();
      }

      final childId = parents.children[0].id;
      final response = await GradeService.fetchGrades(childId);

      if (response != null && response.grades.isNotEmpty) {
        allGrades = response.grades.cast<Grade>();
      } else {
        allGrades = [];
      }

      // Hozirgi tanlangan sana bo‘yicha filter qilish
      filterByDate(selectedDate);
    } catch (e) {
      // Xatolik bo‘lsa ham UI ni bloklamaslik uchun
      allGrades = [];
      _grades = [];
      print("GradesProvider xatosi: $e");
    } finally {
      _finishLoading();
    }
  }

  /// Yuklash tugagandan keyin umumiy funksiya
  void _finishLoading() {
    _isLoading = false;
    notifyListeners();
  }

  /// Tanlangan sana bo‘yicha filter
  void filterByDate(DateTime date) {
    selectedDate = date;
    final formattedDate = formatDate(date);

    _grades = allGrades.where((g) => g.date == formattedDate).toList();
    notifyListeners();
  }

  /// API formatiga mos YYYY-MM-DD
  String formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  /// Yangi refresh funksiyasi (RefreshIndicator uchun)
  Future<void> refresh() async {
    await loadGrades(refresh: true);
  }
}
