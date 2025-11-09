class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String group;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.group,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      group: json['group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'group': group,
    };
  }
}

class Lesson {
  final String day;
  final int lessonNumber;

  Lesson({
    required this.day,
    required this.lessonNumber,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      day: json['day'],
      lessonNumber: json['lessonNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'lessonNumber': lessonNumber,
    };
  }
}

class Homework {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String teacher;
  final Lesson lesson;
  final DateTime assignedDate;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.teacher,
    required this.lesson,
    required this.assignedDate,
  });

  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subject: json['subject'],
      teacher: json['teacher'],
      lesson: Lesson.fromJson(json['lesson']),
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
      'lesson': lesson.toJson(),
      'assignedDate': assignedDate.toIso8601String(),
    };
  }
}

class HomeworkResponse {
  final String message;
  final Student student;
  final int totalHomeworks;
  final List<Homework> homeworks;

  HomeworkResponse({
    required this.message,
    required this.student,
    required this.totalHomeworks,
    required this.homeworks,
  });

  factory HomeworkResponse.fromJson(Map<String, dynamic> json) {
    return HomeworkResponse(
      message: json['message'],
      student: Student.fromJson(json['student']),
      totalHomeworks: json['totalHomeworks'],
      homeworks: (json['homeworks'] as List)
          .map((e) => Homework.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'student': student.toJson(),
      'totalHomeworks': totalHomeworks,
      'homeworks': homeworks.map((e) => e.toJson()).toList(),
    };
  }
}
