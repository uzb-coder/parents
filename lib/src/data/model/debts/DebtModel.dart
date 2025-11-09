class DebtResponse {
  final String message;
  final List<DebtData> data;

  DebtResponse({
    required this.message,
    required this.data,
  });

  factory DebtResponse.fromJson(Map<String, dynamic> json) {
    return DebtResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((e) => DebtData.fromJson(e))
          .toList(),
    );
  }
}

class DebtData {
  final Student student;
  final int monthlyFee;
  final int totalDebt;
  final List<DebtItem> debts;
  final int debtMonthsCount;

  DebtData({
    required this.student,
    required this.monthlyFee,
    required this.totalDebt,
    required this.debts,
    required this.debtMonthsCount,
  });

  factory DebtData.fromJson(Map<String, dynamic> json) {
    return DebtData(
      student: Student.fromJson(json['student']),
      monthlyFee: json['monthlyFee'] ?? 0,
      totalDebt: json['totalDebt'] ?? 0,
      debts: (json['debts'] as List<dynamic>)
          .map((e) => DebtItem.fromJson(e))
          .toList(),
      debtMonthsCount: json['debtMonthsCount'] ?? 0,
    );
  }
}

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final String group;
  final String admissionDate;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.group,
    required this.admissionDate,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      group: json['group'] ?? '',
      admissionDate: json['admissionDate'] ?? '',
    );
  }
}

class DebtItem {
  final String month;
  final String monthName;
  final String year;
  final int monthlyFee;
  final int paidAmount;
  final int? debtAmount;

  DebtItem({
    required this.month,
    required this.monthName,
    required this.year,
    required this.monthlyFee,
    required this.paidAmount,
    this.debtAmount,
  });

  factory DebtItem.fromJson(Map<String, dynamic> json) {
    return DebtItem(
      month: json['month'] ?? '',
      monthName: json['monthName'] ?? '',
      year: json['year'] ?? '',
      monthlyFee: json['monthlyFee'] ?? 0,
      paidAmount: json['paidAmount'] ?? 0,
      debtAmount: json['debtAmount'] ?? 0,
    );
  }
}
