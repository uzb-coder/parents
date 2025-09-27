import 'package:flutter/material.dart';
import '../model/LessonsModel.dart';
import '../scr/Lessons/Lesson_servise.dart';

class TodayLessonsProvider extends ChangeNotifier {
  TodayLessonsResponse? todayLessons;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTodayLessons(DateTime selectedDate) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      todayLessons = await TodayLessonsService.fetchTodayLessons();
      if (todayLessons == null) {
        errorMessage = 'Darslar topilmadi yoki API xatosi';
      } else {
        print('Darslar muvaffaqiyatli yuklandi: ${todayLessons!.data.length} ta');
      }
    } catch (e) {
      print('Provider xatosi: $e');
    }
    isLoading = false;
    notifyListeners();
  }
}