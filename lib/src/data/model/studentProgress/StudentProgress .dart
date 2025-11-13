class StudentProgress {
  final Student? student;
  final double overallProgress; // int emas!
  final List<LastMark> lastMarks;
  final Map<String, double> quarterMarks; // int emas!
  final List<MonthlyMark> monthlyMarks;

  StudentProgress({
    this.student,
    required this.overallProgress,
    required this.lastMarks,
    required this.quarterMarks,
    required this.monthlyMarks,
  });

  factory StudentProgress.fromJson(Map<String, dynamic> json) {
    return StudentProgress(
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      overallProgress: (json['overall_progress'] as num?)?.toDouble() ?? 0.0,
      lastMarks:
          (json['last_marks'] as List?)
              ?.map((m) => LastMark.fromJson(m))
              .toList() ??
          [],
      quarterMarks:
          (json['quarter_marks'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
      monthlyMarks:
          (json['monthly_marks'] as List?)
              ?.map((m) => MonthlyMark.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Student {
  final String id;
  final String fullName;
  final String group;
  final String guardianPhone;

  Student({
    required this.id,
    required this.fullName,
    required this.group,
    required this.guardianPhone,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      group: json['group'] ?? '',
      guardianPhone: json['guardianPhone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'group': group,
      'guardianPhone': guardianPhone,
    };
  }
}

class LastMark {
  final String subject;
  final int mark;
  final String date;

  LastMark({required this.subject, required this.mark, required this.date});

  factory LastMark.fromJson(Map<String, dynamic> json) {
    return LastMark(
      subject: json['subject'] ?? '',
      mark: json['mark'] ?? 0,
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'subject': subject, 'mark': mark, 'date': date};
  }

  String get subjectName {
    final Map<String, String> subjects = {
      'oan-tili': 'Ona tili',
      'matematika': 'Matematika',
      'fizika': 'Fizika',
      'kimyo': 'Kimyo',
      'biologiya': 'Biologiya',
      'tarix': 'Tarix',
      'geografiya': 'Geografiya',
      'adabiyot': 'Adabiyot',
      'ingliz-tili': 'Ingliz tili',
      'rus-tili': 'Rus tili',
      'informatika': 'Informatika',
      'jismoniy-tarbiya': 'Jismoniy tarbiya',
    };
    return subjects[subject.toLowerCase()] ?? subject;
  }
}

class MonthlyMark {
  final String month;
  final double average;

  MonthlyMark({required this.month, required this.average});

  factory MonthlyMark.fromJson(Map<String, dynamic> json) {
    return MonthlyMark(
      month: json['month'] ?? '',
      average: (json['average'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'month': month, 'average': average};
  }

  String get monthName {
    final Map<String, String> months = {
      'january': 'Yanvar',
      'february': 'Fevral',
      'march': 'Mart',
      'april': 'Aprel',
      'may': 'May',
      'june': 'Iyun',
      'july': 'Iyul',
      'august': 'Avgust',
      'september': 'Sentabr',
      'october': 'Oktabr',
      'november': 'Noyabr',
      'december': 'Dekabr',
    };
    return months[month.toLowerCase()] ?? month;
  }
}
