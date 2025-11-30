import 'package:flutter/material.dart';
import 'package:flutter_app/models/review.dart';
import 'star_rating.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({required this.review, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    review.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${review.date.month}/${review.date.day}/${review.date.year}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            StarRating(
              initialRating: review.rating,
              onRatingChanged: (_) {},
              readOnly: true,
              size: 20,
            ),
            SizedBox(height: 8),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

