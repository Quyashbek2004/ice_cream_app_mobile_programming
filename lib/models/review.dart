class Review {
  final String id;
  final String iceCreamId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.iceCreamId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
