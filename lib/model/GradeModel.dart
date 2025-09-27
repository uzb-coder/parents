class GradesResponse {
  final String message;
  final Student student;
  final List<Grade> grades;

  GradesResponse({
    required this.message,
    required this.student,
    required this.grades,
  });

  factory GradesResponse.fromJson(Map<String, dynamic> json) {
    return GradesResponse(
      message: json['message'],
      student: Student.fromJson(json['student']),
      grades: (json['grades'] as List)
          .map((e) => Grade.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'student': student.toJson(),
      'grades': grades.map((e) => e.toJson()).toList(),
    };
  }
}

class Student {
  final String id;
  final String firstName;
  final String lastName;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class Grade {
  final String subject;
  final int lessonNumber;
  final int? grade; // null bo'lishi mumkin
  final String status;
  final String? date; // null bo'lishi mumkin

  Grade({
    required this.subject,
    required this.lessonNumber,
    this.grade,
    required this.status,
    this.date,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      subject: json['subject'],
      lessonNumber: json['lessonNumber'],
      grade: json['grade'],
      status: json['status'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'lessonNumber': lessonNumber,
      'grade': grade,
      'status': status,
      'date': date,
    };
  }
}
