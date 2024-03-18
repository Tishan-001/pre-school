class TeacherModel {
  final String id; // Unique identifier for the student
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String phone;

  TeacherModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory TeacherModel.fromMap(Map<String, dynamic> data, String id) {
    return TeacherModel(
      id: id,
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}