import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'app_view.dart';
import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/review/review_bloc.dart';
import 'services/cart_service.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository: userRepository),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(cartService: CartService()),
        ),
        BlocProvider<ReviewBloc>(
          create: (context) => ReviewBloc(
            reviewRepository: ReviewRepository(),
          ),
        ),
      ],
      child: MyAppView(),
    );
  }
}
