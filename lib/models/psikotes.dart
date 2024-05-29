class Psikotes {
  final String code;
  final String updateDate;
  final String status;

  Psikotes({
    required this.code,
    required this.updateDate,
    required this.status,
  });

  factory Psikotes.fromJson(Map<String, dynamic> json) {
    return Psikotes(
      code: json['code'],
      updateDate: json['updated_at'],
      status: json['status'],
    );
  }
}
