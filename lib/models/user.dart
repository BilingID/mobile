class User {
  int id;
  String fullName;
  String email;
  DateTime dateOfBirth;
  String? profilePhoto;
  String phone;
  String gender;
  String role;
  String bioDesc;
  String skillDesc;
  DateTime createdAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    this.profilePhoto,
    required this.phone,
    required this.gender,
    required this.role,
    required this.bioDesc,
    required this.skillDesc,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final DateTime dob = DateTime.parse(json['data']['user']['date_of_birth']).toLocal();
    final dateOfBirth = DateTime(dob.year, dob.month, dob.day);
    String? profilePhoto = json['data']['user']['profile_photo'];
    if (profilePhoto != null && profilePhoto.contains('localhost')) {
      profilePhoto = profilePhoto.replaceFirst('localhost', '192.168.0.150');
    }
    return User(
      id: json['data']['user']['id'],
      fullName: json['data']['user']['fullname'],
      email: json['data']['user']['email'],
      dateOfBirth: dateOfBirth,
      profilePhoto: profilePhoto,
      phone: json['data']['user']['phone'] ?? '',
      gender: json['data']['user']['gender'],
      role: json['data']['user']['role'],
      bioDesc: json['data']['user']['bio_desc'] ?? '-',
      skillDesc: json['data']['user']['skill_desc'] ?? '-',
      createdAt: DateTime.parse(json['data']['user']['created_at']),
    );
  }

  factory User.fromJsonType2(Map<String, dynamic> json) {
    String? profilePhoto = json['profile_photo'];
    if (profilePhoto != null && profilePhoto.contains('localhost')) {
      profilePhoto = profilePhoto.replaceFirst('localhost', '192.168.0.150');
    }
    return User(
      id: json['id'],
      fullName: json['fullname'],
      email: '',
      dateOfBirth: DateTime.parse('2023-04-01'),
      profilePhoto: profilePhoto,
      phone: '',
      gender: '',
      role: '',
      bioDesc: json['bio_desc'] ?? '-',
      skillDesc: json['skill_desc'] ?? '-',
      createdAt: DateTime.parse('2023-04-01'),
    );
  }

  static List<User> parseList(List<dynamic> list) {
    return list.map((item) => User.fromJsonType2(item)).toList();
  }
}
