class PaymentsResponse {
  final String message;
  final List<PaymentData> data;

  PaymentsResponse({required this.message, required this.data});

  factory PaymentsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentsResponse(
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => PaymentData.fromJson(e))
          .toList(),
    );
  }
}

class PaymentData {
  final Student student;
  final List<Payment> payments;
  final Summary summary;

  PaymentData({
    required this.student,
    required this.payments,
    required this.summary,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      student: Student.fromJson(json['student']),
      payments: (json['payments'] as List)
          .map((e) => Payment.fromJson(e))
          .toList(),
      summary: Summary.fromJson(json['summary']),
    );
  }
}

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
}

class Payment {
  final int amount;
  final String method;
  final String month;
  final String status;

  Payment({
    required this.amount,
    required this.method,
    required this.month,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: json['amount'],
      method: json['method'],
      month: json['month'],
      status: json['status'],
    );
  }
}

class Summary {
  final int monthlyFee;
  final int totalPaid;
  final int remainingDebt;

  Summary({
    required this.monthlyFee,
    required this.totalPaid,
    required this.remainingDebt,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      monthlyFee: json['monthlyFee'],
      totalPaid: json['totalPaid'],
      remainingDebt: json['remainingDebt'],
    );
  }
}
