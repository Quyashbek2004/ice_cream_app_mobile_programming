import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_app/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Review>> getReviewsForProduct(String iceCreamId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('iceCreamId', isEqualTo: iceCreamId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Review(
                id: doc.id,
                iceCreamId: doc['iceCreamId'] ?? '',
                userId: doc['userId'] ?? '',
                userName: doc['userName'] ?? 'Anonymous',
                rating: (doc['rating'] ?? 0).toDouble(),
                comment: doc['comment'] ?? '',
                date: doc['date'] is Timestamp
                    ? (doc['date'] as Timestamp).toDate()
                    : DateTime.now(),
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<double> getAverageRating(String iceCreamId) async {
    try {
      final reviews = await getReviewsForProduct(iceCreamId);
      if (reviews.isEmpty) return 0.0;
      final sum = reviews.fold<double>(0, (sum, review) => sum + review.rating);
      return sum / reviews.length;
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> submitReview({
    required String iceCreamId,
    required String userId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    try {
      await _firestore.collection('reviews').add({
        'iceCreamId': iceCreamId,
        'userId': userId,
        'userName': userName,
        'rating': rating,
        'comment': comment,
        'date': Timestamp.now(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }
}

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

      final updatedReviews = Map<String, List<Review>>.from(state.reviews);
      updatedReviews[event.iceCreamId] = reviews;

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
