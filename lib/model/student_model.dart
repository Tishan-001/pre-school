class StudentModel {
  final String id; // Unique identifier for the student
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String phone;
  final String? profilePictureUrl;
  final bool accept;

  StudentModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
    required this.profilePictureUrl,
    required this.accept,
  });

  factory StudentModel.fromMap(Map<String, dynamic> data, String id) {
    return StudentModel(
      id: id,
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phone: data['phone'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      accept: data['accept'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'phone': phone,
      'profilePictureUrl': profilePictureUrl,
      'accept': accept,
    };
  }
}
