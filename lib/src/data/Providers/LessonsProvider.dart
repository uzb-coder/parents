import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/lesson/LessonsModel.dart';
import '../services/lesson/Lesson_servise.dart';
import 'dart:convert';

class TodayLessonsProvider extends ChangeNotifier {
  HomeworkResponse? todayLessons;
  bool isLoading = false;
  String? errorMessage;
  String? _cachedStudentId;
  String? _cachedStudentName;

  Future<String?> _getStudentId() async {
    if (_cachedStudentId != null) {
      return _cachedStudentId;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      final parentsData = prefs.getString('parents_data');

      if (parentsData != null) {
        final json = jsonDecode(parentsData);

        // Children array dan birinchi bolani olish
        if (json['children'] != null &&
            json['children'] is List &&
            json['children'].isNotEmpty) {
          _cachedStudentId = json['children'][0]['id'];
          _cachedStudentName =
              "${json['children'][0]['firstName']} ${json['children'][0]['lastName']}";

          return _cachedStudentId;
        }
      }

      // Agar parents_data bo'lmasa, to'g'ridan-to'g'ri student_id ni tekshirish
      _cachedStudentId = prefs.getString('selected_student_id');
      return _cachedStudentId;
    } catch (e) {
      print('Student ID ni olishda xatolik: $e');
      return null;
    }
  }

  /// Barcha bolalarni olish (agar bir nechta bola bo'lsa)
  Future<List<Map<String, dynamic>>> getAllChildren() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final parentsData = prefs.getString('parents_data');

      if (parentsData != null) {
        final json = jsonDecode(parentsData);

        if (json['children'] != null && json['children'] is List) {
          return List<Map<String, dynamic>>.from(json['children']);
        }
      }

      return [];
    } catch (e) {
      print('Bolalarni olishda xatolik: $e');
      return [];
    }
  }

  Future<void> selectStudent(String studentId, String studentName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_student_id', studentId);
      _cachedStudentId = studentId;
      _cachedStudentName = studentName;

      await loadTodayLessons(DateTime.now());
    } catch (e) {
      print('Student tanlashda xatolik: $e');
    }
  }

  /// Tanlangan sana uchun darslarni yuklash
  Future<void> loadTodayLessons(DateTime selectedDate) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Student ID ni olish
      final studentId = await _getStudentId();

      if (studentId == null || studentId.isEmpty) {
        isLoading = false;
        notifyListeners();
        return;
      }
      todayLessons = await TodayLessonsService.fetchTodayLessons(studentId);
    } catch (e) {
      print('❌ Provider xatosi: $e');
      errorMessage = 'Darslarni yuklashda xatolik yuz berdi: ${e.toString()}';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Ma'lumotlarni tozalash (logout paytida)
  void clearData() {
    todayLessons = null;
    errorMessage = null;
    _cachedStudentId = null;
    _cachedStudentName = null;
    notifyListeners();
  }

  /// Cached student ma'lumotlarini olish
  String? get currentStudentId => _cachedStudentId;
  String? get currentStudentName => _cachedStudentName;

  /// Student tanlangan yoki yo'qligini tekshirish
  bool get hasStudent => _cachedStudentId != null;
}
