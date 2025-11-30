import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_app/models/review.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  ReviewBloc({required ReviewRepository reviewRepository})
      : _reviewRepository = reviewRepository,
        super(const ReviewState()) {
    on<FetchReviews>(_onFetchReviews);
    on<SubmitReview>(_onSubmitReview);
  }

  Future<void> _onFetchReviews(
    FetchReviews event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final reviews = await _reviewRepository.getReviewsForProduct(event.iceCreamId);
      final average = await _reviewRepository.getAverageRating(event.iceCreamId);

      final reviewList = reviews
          .map((r) => Review(
                id: r.id,
                iceCreamId: r.iceCreamId,
                userId: r.userId,
                userName: r.userName,
                rating: r.rating,
                comment: r.comment,
                date: r.date,
              ))
          .toList();

      final updatedReviews = Map<String, List<Review>>.from(state.reviews);
      updatedReviews[event.iceCreamId] = reviewList;

      final updatedAverages = Map<String, double>.from(state.averageRatings);
      updatedAverages[event.iceCreamId] = average;

      emit(state.copyWith(
        reviews: updatedReviews,
        averageRatings: updatedAverages,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load reviews',
      ));
    }
  }

  Future<void> _onSubmitReview(
    SubmitReview event,
    Emitter<ReviewState> emit,
  ) async {
    try {
      await _reviewRepository.submitReview(
        iceCreamId: event.iceCreamId,
        userId: event.userId,
        userName: event.userName,
        rating: event.rating,
        comment: event.comment,
      );

      // Refresh reviews after submission
      add(FetchReviews(event.iceCreamId));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to submit review'));
    }
  }
}
