import 'package:flutter/material.dart';
import '../model/lesson/LessonsModel.dart';
import '../services/lesson/Lesson_servise.dart';

class TodayLessonsProvider extends ChangeNotifier {
  HomeworkResponse? todayLessons;
  bool isLoading = false;
  String? errorMessage;

  /// Bugungi darslarni yuklash
  Future<void> loadTodayLessons(DateTime fullDat) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await TodayLessonsService.fetchTodayLessons();

      if (response != null) {
        todayLessons = response;
      } else {
        errorMessage = 'Maʼlumot topilmadi.';
      }
    } catch (e) {
      print('❌ Provider xatosi: $e');
      errorMessage = 'Darslarni yuklashda xatolik yuz berdi.';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Maʼlumotlarni tozalash (logout paytida)
  void clearData() {
    todayLessons = null;
    errorMessage = null;
    notifyListeners();
  }
}
