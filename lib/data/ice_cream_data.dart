// lib/data/dummy_data.dart
import '../models/ice_cream.dart';

final List<IceCream> iceCreamList = [
  IceCream(
    id: 'ic1',
    name: 'Strawberry Delight',
    description:
        'A very delicious ice-cream with fresh strawberries and pure milk!',
    imageUrl: 'assets/1.png',
    price: 8.00,
    oldPrice: 10.00,
    tags: ['Ultra Milk'],
    macros: [
      // Strawberry should be fruit-forward: Fruits has the highest value
      Macro(title: 'Milk', value: 60, emoji: '🥛'),
      Macro(title: 'Sugar', value: 20, emoji: '🍬'),
    ],
  ),
  IceCream(
    id: 'ic2',
    name: 'Chocolate Dream',
    description:
        'Rich chocolate ice-cream with chocolate chips and a creamy texture.',
    imageUrl: 'assets/2.png',
    price: 9.50,
    oldPrice: 12.00,
    tags: ['Chocolate', 'Creamy'],
    macros: [
      // Chocolate-forward: Chocolate has the highest value
      Macro(title: 'Chocolate', value: 90, emoji: '🍫'), // Category: Chocolate
      Macro(title: 'Sugar', value: 30, emoji: '🍬'),
    ],
  ),
  IceCream(
    id: 'ic3',
    name: 'Vanilla Classic',
    description:
        'The timeless classic, smooth and rich vanilla bean ice-cream.',
    imageUrl: 'assets/3.png',
    price: 7.00,
    oldPrice: 9.00,
    tags: ['Vanilla', 'Classic'],
    macros: [
      // Vanilla is milk-forward
      Macro(title: 'Milk', value: 95, emoji: '🥛'), // Category: Milk
      Macro(title: 'Sugar', value: 25, emoji: '🍬'),
    ],
  ),
  IceCream(
    id: 'ic4',
    name: 'Mint Chocolate Chip',
    description: 'Refreshing mint ice-cream with decadent chocolate chips.',
    imageUrl: 'assets/4.png',
    price: 8.50,
    oldPrice: 10.00,
    tags: ['Mint', 'Chocolate'],
    macros: [
      // Mint chocolate should be chocolate-forward
      Macro(title: 'Chocolate', value: 70, emoji: '🍫'), // Category: Chocolate
      Macro(title: 'Mint', value: 15, emoji: '🍃'), // flavor detail
    ],
  ),
  IceCream(
    id: 'ic5',
    name: 'Blueberry Swirl',
    description: 'Creamy ice-cream swirled with sweet and tart blueberries.',
    imageUrl: 'assets/5.png',
    price: 9.00,
    oldPrice: 11.00,
    tags: ['Blueberry', 'Fruity'],
    macros: [
      // Blueberry should be fruit-forward
      Macro(title: 'Fruits', value: 85, emoji: '🫐'), // Category: Fruits
      Macro(title: 'Sugar', value: 22, emoji: '🍬'),
    ],
  ),
  IceCream(
    id: 'ic6',
    name: 'Oreo Crunch',
    description: 'Oreo flavored ice-cream with crunchy toffee bits.',
    imageUrl: 'assets/9.png',
    price: 9.25,
    oldPrice: 10.50,
    tags: ['Coffee', 'Crunchy'],
    macros: [
      // Coffee is typically milk-forward ice-cream with coffee flavor
      Macro(title: 'Chocolate', value: 80, emoji: '🍫'), // Category: Milk
      Macro(title: 'Sugar', value: 28, emoji: '🍬'),
      Macro(title: 'Coffee', value: 35, emoji: '☕'), // flavor detail
    ],
  ),
  IceCream(
    id: 'ic7',
    name: 'Mango Tango',
    description: 'Tropical mango ice-cream with a tangy twist.',
    imageUrl: 'assets/7.png',
    price: 8.75,
    oldPrice: 10.50,
    tags: ['Milky', 'Soft'],
    macros: [
      // Mango should be fruit-forward
      Macro(title: 'Milk', value: 55, emoji: '🥛'),
      Macro(title: 'Sugar', value: 20, emoji: '🍬'),
    ],
  ),
  IceCream(
    id: 'ic8',
    name: 'Pistachio Dream',
    description: 'Nutty pistachio ice-cream with real pistachio pieces.',
    imageUrl: 'assets/8.png',
    price: 9.75,
    oldPrice: 11.50,
    tags: ['Pistachio', 'Nutty'],
    macros: [
      // Pistachio is generally milk-forward with nutty flavor
      Macro(title: 'Fruits', value: 80, emoji: '🫐'), // Category: Milk
      Macro(title: 'Sugar', value: 23, emoji: '🍬'),
      Macro(title: 'Nuts', value: 30, emoji: '🌰'), // flavor detail
    ],
  ),
  IceCream(
    id: 'ic9',
    name: 'Colorful Light',
    description: 'Remember childhood with this colorful and light ice-cream.',
    imageUrl: 'assets/6.png',
    price: 9.75,
    oldPrice: 11.50,
    tags: ['Cherry', 'Soft'],
    macros: [
      // Pistachio is generally milk-forward with nutty flavor
      Macro(title: 'Fruits', value: 80, emoji: '🫐'), // Category: Milk
      Macro(title: 'Sugar', value: 23, emoji: '🍬'),
    ],
  ),
];
