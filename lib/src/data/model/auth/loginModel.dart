// models/guardian.dart
class Guardian {
  final String name;
  final String phoneNumber;

  Guardian({
    required this.name,
    required this.phoneNumber,
  });

  factory Guardian.fromJson(Map<String, dynamic> json) {
    return Guardian(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}

// models/child.dart
class Child {
  final String id;
  final String firstName;
  final String lastName;
  final String groupId;
  final String schoolId;

  Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.groupId,
    required this.schoolId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      groupId: json['groupId'] ?? '',
      schoolId: json['schoolId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'groupId': groupId,
      'schoolId': schoolId,
    };
  }

  String get fullName => '$firstName $lastName';

  get guardianPhone => null;
}

// models/parents.dart
class Parents {
  final String message;
  final String token;
  final Guardian guardian;
  final List<Child> children;

  Parents({
    required this.message,
    required this.token,
    required this.guardian,
    required this.children,
  });

  factory Parents.fromJson(Map<String, dynamic> json) {
    var childrenList = json['children'] as List? ?? [];
    List<Child> children = childrenList.map((child) => Child.fromJson(child)).toList();

    return Parents(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      guardian: Guardian.fromJson(json['guardian'] ?? {}),
      children: children,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'guardian': guardian.toJson(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}