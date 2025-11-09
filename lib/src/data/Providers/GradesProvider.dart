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

  Future<void> loadGrades() async {
    _isLoading = true;
    notifyListeners();

    final parents = await LoginService.getSavedParents();
    if (parents == null || parents.children.isEmpty) {
      _grades = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    final childId = parents.children[0].id;
    final response = await GradeService.fetchGrades(childId);

    if (response != null) {
      allGrades = response.grades.cast<Grade>();
      filterByDate(selectedDate);

      /// ✅ bugungi kun bo‘yicha filter
    } else {
      _grades = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Tanlangan sana bo‘yicha filter
  void filterByDate(DateTime date) {
    selectedDate = date;

    _grades =
        allGrades.where((g) {
          return g.date == formatDate(date);
        }).toList();

    notifyListeners();
  }

  /// ✅ API formatiga mos YYYY-MM-DD qaytaradi
  String formatDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
}
