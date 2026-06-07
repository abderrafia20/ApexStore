class RatingModel {
  final double rate;
  final int count;

  RatingModel({
    required this.rate,
    required this.count,
  });

  // Factory constructor to parse JSON response safely
  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      // Safely parsing double since API might return int (like 4) instead of double (4.0)
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }

  // Convert model back to JSON map
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
