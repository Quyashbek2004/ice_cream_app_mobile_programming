import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/components/macro.dart';
import 'package:flutter_app/models/ice_cream.dart';
import 'package:flutter_app/blocs/review/review_bloc.dart';
import 'package:flutter_app/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_app/components/star_rating.dart';
import 'package:flutter_app/components/review_card.dart';
import 'review_sheet.dart';

class DetailsScreen extends StatefulWidget {
  final IceCream iceCream;

  const DetailsScreen({super.key, required this.iceCream});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewBloc>().add(FetchReviews(widget.iceCream.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        title: Text(widget.iceCream.name),
      ),
      backgroundColor: Colors.pink.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 244, 93, 176),
                    borderRadius: BorderRadiusDirectional.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(3, 3),
                        blurRadius: 5,
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(widget.iceCream.imageUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(3, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.iceCream.name,
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "\$${widget.iceCream.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                if (widget.iceCream.oldPrice != null)
                                  Text(
                                    "\$${widget.iceCream.oldPrice!.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 1.5,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4),
                        child: Text(
                          widget.iceCream.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              ...widget.iceCream.macros
                                  .map((macro) => Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: MyMacro(
                                          title: macro.title,
                                          value: macro.value,
                                          emoji: macro.emoji,
                                        ),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocBuilder<ReviewBloc, ReviewState>(
                        builder: (context, state) {
                          final averageRating =
                              state.getAverageRating(widget.iceCream.id);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Average Rating',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        StarRating(
                                          initialRating: averageRating,
                                          onRatingChanged: (_) {},
                                          readOnly: true,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          averageRating > 0
                                              ? '${averageRating.toStringAsFixed(1)}/5'
                                              : 'No ratings',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => ReviewSheet(
                                        iceCreamId: widget.iceCream.id,
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Review'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade200,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        height: 60,
                        child: TextButton(
                          onPressed: () {
                            // Buy now action
                          },
                          style: TextButton.styleFrom(
                            elevation: 3,
                            backgroundColor: Colors.blue.shade200,
                          ),
                          child: Text(
                            "Buy now!",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, state) {
                    final reviews = state.getReviews(widget.iceCream.id);
                    if (state.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Text(
                            'Customer Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        if (reviews.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No reviews yet. Be the first!'),
                          )
                        else
                          ...reviews
                              .map((review) => ReviewCard(review: review))
                              .toList(),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}