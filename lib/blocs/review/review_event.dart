part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class FetchReviews extends ReviewEvent {
  final String iceCreamId;

  const FetchReviews(this.iceCreamId);

  @override
  List<Object> get props => [iceCreamId];
}

class LoadReviews extends ReviewEvent {
  final String iceCreamId;

  const LoadReviews(this.iceCreamId);

  @override
  List<Object> get props => [iceCreamId];
}

class SubmitReview extends ReviewEvent {
  final String iceCreamId;
  final String userId;
  final double rating;
  final String comment;
  final String userName;

  const SubmitReview({
    required this.iceCreamId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.userName,
  });

  @override
  List<Object> get props => [iceCreamId, userId, rating, comment, userName];
}
