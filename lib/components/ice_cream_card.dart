import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/ice_cream.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/blocs/cart/cart_bloc.dart';
import 'package:flutter_app/screens/home/views/details_screen.dart'; // <-- your details page

class YourIceCreamCard extends StatelessWidget {
  final IceCream iceCream;

  const YourIceCreamCard({Key? key, required this.iceCream}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Material(
        elevation: 3,
        color: Colors.pink.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => DetailsScreen(
                  iceCream: iceCream,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Image.asset(
                iceCream.imageUrl,
                width: 220,
                height: 220,
              ),

              // Tags
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    ...iceCream.tags.map(
                      (tag) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: tag == 'Strawberry'
                                ? Colors.pinkAccent
                                : Colors.blue.shade100,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 6,
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  iceCream.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  iceCream.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              // Price + Add button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "\$${iceCream.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (iceCream.oldPrice != null)
                          Text(
                            "\$${iceCream.oldPrice!.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<CartBloc>().add(AddCartItem(iceCream));
                        // Optionally show feedback:
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${iceCream.name} added to cart')),
                        );
                      },
                      icon: const Icon(CupertinoIcons.add_circled_solid),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
