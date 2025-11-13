class HomeworkResponse {
  final String message;
  final String date;
  final List<StudentData> data;

  HomeworkResponse({
    required this.message,
    required this.date,
    required this.data,
  });

  factory HomeworkResponse.fromJson(Map<String, dynamic> json) {
    return HomeworkResponse(
      message: json['message'],
      date: json['date'],
      data: (json['data'] as List)
          .map((e) => StudentData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'date': date,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentData {
  final String student;
  final String group;
  final List<Lesson> lessons;

  StudentData({
    required this.student,
    required this.group,
    required this.lessons,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      student: json['student'],
      group: json['group'],
      lessons:
          (json['lessons'] as List).map((e) => Lesson.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student': student,
      'group': group,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}

class Lesson {
  final String subject;
  final int lessonNumber;
  final String teacher;
  final List<Homework> homeworks;

  Lesson({
    required this.subject,
    required this.lessonNumber,
    required this.teacher,
    required this.homeworks,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      subject: json['subject'],
      lessonNumber: json['lessonNumber'],
      teacher: json['teacher'],
      homeworks: (json['homeworks'] as List)
          .map((e) => Homework.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'lessonNumber': lessonNumber,
      'teacher': teacher,
      'homeworks': homeworks.map((e) => e.toJson()).toList(),
    };
  }
}

class Homework {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String teacher;
  final DateTime assignedDate;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.teacher,
    required this.assignedDate,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subject: json['subject'],
      teacher: json['teacher'],
      assignedDate: DateTime.parse(json['assignedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'teacher': teacher,
      'assignedDate': assignedDate.toIso8601String(),
    };
  }
}
