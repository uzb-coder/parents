import 'package:parents/src/data/model/GradeModel.dart';
import 'package:parents/src/data/services/grade/GradeService.dart';
import 'package:parents/src/library/librarys.dart';

class GradesProvider extends ChangeNotifier {
  List<Grade> _grades = [];
  bool _isLoading = false;

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
      _grades = response.grades.cast<Grade>();
    } else {
      _grades = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
