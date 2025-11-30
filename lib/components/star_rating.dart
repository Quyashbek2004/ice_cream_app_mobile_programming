import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final double initialRating;
  final Function(double) onRatingChanged;
  final double size;
  final bool readOnly;

  const StarRating({
    required this.initialRating,
    required this.onRatingChanged,
    this.size = 32,
    this.readOnly = false,
    super.key,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.readOnly
              ? null
              : () {
                  setState(() {
                    _currentRating = (index + 1).toDouble();
                  });
                  widget.onRatingChanged(_currentRating);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              index < _currentRating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: widget.size,
            ),
          ),
        );
      }),
    );
  }
}

