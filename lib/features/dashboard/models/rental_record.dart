/// A tenant's rent (yearly lease) or shortlet booking for one property,
/// shown on the History screen. Keyed by property id in [AppState].
class RentalRecord {
  const RentalRecord({required this.startDate, required this.endDate, this.rating});

  final DateTime startDate;
  final DateTime endDate;

  /// The tenant's own star rating (1-5) for this stay/lease, given from the
  /// History screen. Null until they rate it.
  final double? rating;

  bool get isActive => DateTime.now().isBefore(endDate);

  RentalRecord copyWith({DateTime? startDate, DateTime? endDate, double? rating}) {
    return RentalRecord(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'rating': rating,
  };

  static RentalRecord fromJson(Map<String, dynamic> json) => RentalRecord(
    startDate: DateTime.parse(json['startDate'] as String),
    endDate: DateTime.parse(json['endDate'] as String),
    rating: (json['rating'] as num?)?.toDouble(),
  );
}
