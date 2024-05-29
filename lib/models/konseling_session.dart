class KonselingSession {
  int id;
  String meetDate;
  String meetTime;
  String meetUrl;
  int psychologistId;
  String psychologistFullName;
  int userId;
  String userFullName;
  String status;
  String attachmentPath;

  KonselingSession({
    required this.id,
    required this.meetDate,
    required this.meetTime,
    required this.meetUrl,
    required this.psychologistId,
    required this.psychologistFullName,
    required this.userId,
    required this.userFullName,
    required this.status,
    required this.attachmentPath,
  });

  factory KonselingSession.fromJson(Map<String, dynamic> json) {
    String? attachmentPath = json['result']['attachment_path'];
    if (attachmentPath != null && attachmentPath.contains('localhost')) {
      attachmentPath =
          attachmentPath.replaceFirst('localhost', '192.168.0.150');
    }
    return KonselingSession(
      id: json['id'],
      meetDate: json['meet_date'],
      meetTime: json['meet_time'],
      meetUrl: json['meet_url'],
      psychologistId: json['psychologist']['id'],
      psychologistFullName: json['psychologist']['fullname'],
      userId: json['user']['id'],
      userFullName: json['user']['fullname'],
      status: json['result']['status'],
      // wait and finish
      attachmentPath: attachmentPath ?? '',
    );
  }
}
