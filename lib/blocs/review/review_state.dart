part of 'review_bloc.dart';

class ReviewState extends Equatable {
  final Map<String, List<Review>> reviews;
  final Map<String, double> averageRatings;
  final bool isLoading;
  final String? errorMessage;

  const ReviewState({
    this.reviews = const {},
    this.averageRatings = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  List<Review> getReviews(String iceCreamId) => reviews[iceCreamId] ?? [];

  double getAverageRating(String iceCreamId) => averageRatings[iceCreamId] ?? 0.0;

  ReviewState copyWith({
    Map<String, List<Review>>? reviews,
    Map<String, double>? averageRatings,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      averageRatings: averageRatings ?? this.averageRatings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [reviews, averageRatings, isLoading, errorMessage];
}

