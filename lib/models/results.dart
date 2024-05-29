class Results {
  String personality;
  String description;

  Results({
    required this.personality,
    required this.description,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      personality: json['data']['personality'],
      description: json['data']['description'],
    );
  }
}
