import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:movie_app/screens/home/blocs/bloc/get_movie_bloc/get_movie_bloc.dart';
import 'package:movie_repository/movie_repository.dart';

import 'screens/auth/views/welcome_screen.dart';
import 'screens/home/views/home_screen.dart';
import 'screens/home/blocs/bloc/my_user_bloc/my_user_bloc.dart';
import 'package:movie_app/screens/home/blocs/bloc/update_user_bloc/update_user_bloc.dart';

class MyAppView extends StatelessWidget {
   const MyAppView({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: ColorScheme.light(background: Colors.grey.shade300, onBackground: Colors.black, primary: Colors.blue, onPrimary: Colors.white)),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
										create: (context) => UpdateUserBloc(
											context.read<AuthenticationBloc>().userRepository
										),
                    
									),
                  BlocProvider(
                    create: (context) => GetMovieBloc(
                      FirebaseMovieRepo()
                    )..add(GetMovie()),
                  ),                  
                  BlocProvider(
										create: (context) => MyUserBloc(
											myUserRepository: context.read<AuthenticationBloc>().userRepository
										)..add(GetMyUser(
											myUserId: context.read<AuthenticationBloc>().state.user!.userId
										)),
									),
                ],
                child: HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          }),
        ));
  }
}
