class Activity {
  final int id;
  final String userId;
  final String? user;
  final String title;
  final String description;
  final double estimateWeight; // Added field
  final String points; // Added field
  final DateTime date;
  final DateTime createdAt;

  Activity({
    required this.id,
    required this.userId,
    this.user,
    required this.title,
    required this.description,
    required this.estimateWeight, // Added field
    required this.points, // Added field
    required this.date,
    required this.createdAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      userId: json['userId'],
      user: json['user'],
      title: json['title'],
      description: json['description'],
      estimateWeight: (json['estimateWeight'] as num).toDouble(), // Added field
      points: json['points'], // Added field
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user,
      'title': title,
      'description': description,
      'estimateWeight': estimateWeight, // Added field
      'points': points, // Added field
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}