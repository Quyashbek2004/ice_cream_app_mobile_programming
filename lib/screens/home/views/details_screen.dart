import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/components/macro.dart';
import 'package:flutter_app/models/ice_cream.dart';
import 'package:flutter_app/blocs/review/review_bloc.dart';
import 'package:flutter_app/blocs/cart/cart_bloc.dart';
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
        elevation: 0,
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
                const SizedBox(height: 30),
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
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${widget.iceCream.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
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
                      const SizedBox(height: 15),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              ...widget.iceCream.macros
                                  .map((macro) => Padding(
                                        padding:
                                            const EdgeInsets.symmetric(horizontal: 8.0),
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
                      const SizedBox(height: 20),
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
                                    const Text(
                                      'Average Rating',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        StarRating(
                                          initialRating: averageRating,
                                          onRatingChanged: (_) {},
                                          readOnly: true,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          averageRating > 0
                                              ? '${averageRating.toStringAsFixed(1)}/5'
                                              : 'No ratings',
                                          style: const TextStyle(fontSize: 14),
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
                                    ).then((_) {
                                      context.read<ReviewBloc>().add(
                                        FetchReviews(widget.iceCream.id),
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Review'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: MouseRegion(
                          child: GestureDetector(
                            onTapDown: (_) {
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pinkAccent.shade100,
                                    Colors.pinkAccent.shade200,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.pinkAccent.withOpacity(0.4),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context.read<CartBloc>().add(AddCartItem(widget.iceCream));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(Icons.check_circle, color: Colors.white),
                                            const SizedBox(width: 12),
                                            Text('${widget.iceCream.name} added to cart!'),
                                          ],
                                        ),
                                        backgroundColor: Colors.green.shade400,
                                        duration: const Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.all(16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, state) {
                    final reviews = state.getReviews(widget.iceCream.id);
                    if (state.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Loading reviews...'),
                          ],
                        ),
                      );
                    }

                    if (state.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: 32),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ReviewBloc>().add(
                                  FetchReviews(widget.iceCream.id),
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Text(
                            'Customer Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (reviews.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
