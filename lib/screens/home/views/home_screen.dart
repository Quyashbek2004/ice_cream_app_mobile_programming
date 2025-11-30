import 'package:flutter/material.dart';

import '../../../components/ice_cream_card.dart';
import '../../../data/ice_cream_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade100,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Assuming logo.png exists
              height: 50,
              width: 50,
              scale: 3,
            ),
            SizedBox(width: 8),
            Text(
              'Ice-Cream',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(24),
            child: Image.asset(
              'assets/discount.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          // HomePage widget
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MILK Category
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Milk",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 450, // same as your GridView height
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                  ),
                  itemCount: iceCreamList
                      .where((ic) => ic.macros.any((m) => m.title == "Milk"))
                      .length,
                  itemBuilder: (context, i) {
                    final milkList = iceCreamList
                        .where((ic) => ic.macros.any((m) => m.title == "Milk"))
                        .toList();
                    final iceCream = milkList[i];

                    // 👉 your existing card code (DON’T change design)
                    return YourIceCreamCard(iceCream: iceCream);
                  },
                ),
              ),

              // CHOCOLATE Category
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Chocolate",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 450,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                  ),
                  itemCount: iceCreamList
                      .where(
                        (ic) => ic.macros.any((m) => m.title == "Chocolate"),
                      )
                      .length,
                  itemBuilder: (context, i) {
                    final chocoList = iceCreamList
                        .where(
                          (ic) => ic.macros.any((m) => m.title == "Chocolate"),
                        )
                        .toList();
                    final iceCream = chocoList[i];

                    return YourIceCreamCard(iceCream: iceCream);
                  },
                ),
              ),

              // FRUITS Category
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Fruits",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              SizedBox(
                height: 450,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                  ),
                  itemCount: iceCreamList
                      .where((ic) => ic.macros.any((m) => m.title == "Fruits"))
                      .length,
                  itemBuilder: (context, i) {
                    final fruitList = iceCreamList
                        .where(
                          (ic) => ic.macros.any((m) => m.title == "Fruits"),
                        )
                        .toList();
                    final iceCream = fruitList[i];

                    return YourIceCreamCard(iceCream: iceCream);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
