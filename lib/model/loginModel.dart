class Parents {
  final String id;
  final String firstName;
  final String lastName;
  final String groupId;
  final String schoolId;

  Parents({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.groupId,
    required this.schoolId,
  });

  factory Parents.fromJson(Map<String, dynamic> json) {
    return Parents(
      id: json['id'] ?? "",
      firstName: json['firstName'] ?? "",
      lastName: json['lastName'] ?? "",
      groupId: json['groupId'] ?? "",
      schoolId: json['schoolId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "groupId": groupId,
      "schoolId": schoolId,
    };
  }
}
