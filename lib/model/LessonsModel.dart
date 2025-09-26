class TodayLessonsResponse {
  final String message;
  final List<StudentLessons> data;
  DateTime date;

  TodayLessonsResponse({
    required this.message,
    required this.data,
    required this.date,
  });

  factory TodayLessonsResponse.fromJson(Map<String, dynamic> json) {
    return TodayLessonsResponse(
      message: json['message'] ?? '',
      date: DateTime.parse(json['date']), // <-- shu yerda vaqtni olamiz
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => StudentLessons.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class StudentLessons {
  final String student;
  final String group;
  final List<Lesson> lessons;

  StudentLessons({
    required this.student,
    required this.group,
    required this.lessons,
  });

  factory StudentLessons.fromJson(Map<String, dynamic> json) {
    return StudentLessons(
      student: json['student'] ?? '',
      group: json['group'] ?? '',
      lessons:
          (json['lessons'] as List<dynamic>?)
              ?.map((e) => Lesson.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Lesson {
  final String subject;
  final int lessonNumber;
  final String teacher;

  Lesson({
    required this.subject,
    required this.lessonNumber,
    required this.teacher,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      subject: json['subject'] ?? '',
      lessonNumber: json['lessonNumber'] ?? 0,
      teacher: json['teacher'] ?? '',
    );
  }
}
