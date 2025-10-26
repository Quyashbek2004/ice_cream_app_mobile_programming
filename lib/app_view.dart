import 'package:flutter/material.dart';
import 'package:flutter_app/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_app/screens/home/views/cart.dart';
import 'package:flutter_app/screens/home/views/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'screens/authentication/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'screens/authentication/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ice-Cream Shop',
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) =>
                  SignInBloc(context.read<AuthenticationBloc>().userRepository),
              child: Scaffold(
                backgroundColor: Colors.pink.shade100,
                body: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  children: [HomeScreen(), Cart(), Settings()],
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.pink.shade200,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: GNav(
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                          _pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                        },
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        gap: 8,
                        iconSize: 32,
                        backgroundColor: Colors.pink.shade200,
                        tabBackgroundColor: Colors.pink.shade100,
                        padding: const EdgeInsets.all(10),
                        tabs: [
                          GButton(
                            icon: Icons.home,
                            text: 'Home',
                            textColor: Colors.pink,
                          ),
                          GButton(
                            icon: Icons.shopping_cart,
                            text: 'Cart',
                            textColor: Colors.pink,
                          ),
                          GButton(
                            icon: Icons.settings,
                            text: 'Settings',
                            textColor: Colors.pink,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
