import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:movie_app/screens/home/blocs/bloc/get_movie_bloc/get_movie_bloc.dart';
import 'package:movie_app/screens/home/views/favorites_screen.dart';
import 'package:movie_app/screens/home/views/movies_screen.dart';
import 'package:movie_app/screens/home/views/user_screen.dart';
import 'package:movie_repository/movie_repository.dart';
import '../blocs/bloc/my_user_bloc/my_user_bloc.dart';
import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/bloc/update_user_bloc/update_user_bloc.dart';
import 'package:movie_app/components/lists.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCountry = 'None'; // Initial selected country
  String selectedGenre = 'None'; // Initial selected genre
  String? selectedYearDirection;

  void refreshData() {    
    context.read<GetMovieBloc>().add(
      GetMovie(),
    );
  }

  void onGoBack(dynamic value) {    
    setState(() {
      refreshData();
    });
  }


void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.background,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Years'),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Radio(
                          value: 'up',
                          groupValue: selectedYearDirection,
                          onChanged: (value) {
                            setState(() {
                              selectedYearDirection = value.toString();
                            });
                          },
                        ),
                        const Icon(Icons.arrow_upward),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'down',
                          groupValue: selectedYearDirection,
                          onChanged: (value) {
                            setState(() {
                              selectedYearDirection = value.toString();
                            });
                          },
                        ),
                        const Icon(Icons.arrow_downward),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Select Country:'),
                DropdownButton<String>(
                  value: selectedCountry,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCountry = newValue!;
                    });
                  },
                  items: Lists.countries.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Select Genre:'),
                DropdownButton<String>(
                  value: selectedGenre,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGenre = newValue!;
                    });
                  },
                  items: Lists.genres.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        selectedYearDirection = null;
                        selectedCountry = 'None';
                        selectedGenre = 'None';
                        Navigator.pop(context); // Close the bottom sheet
                        applyFilters();
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        
                        Navigator.pop(context); 
                        applyFilters();
                        
                      },
                      child: const Text('Apply filters'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


void applyFilters() {
  setState(() {
    refreshData();
  });
}


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('building homescreen');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Row(
          children: [
            Icon(CupertinoIcons.film),
            SizedBox(width: 8),
            Text(
              'MOVIES',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            )
          ],
        ),
        
        actions: [          
          IconButton(
            onPressed: () {          
              Navigator.push(
                context, 
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<MyUserBloc>(
                          create: (context) => MyUserBloc(
                            myUserRepository: context.read<AuthenticationBloc>().userRepository,
                          )..add(GetMyUser(myUserId: context.read<AuthenticationBloc>().state.user!.userId)),
                        ),
                        BlocProvider(
                          create: (context) => UpdateUserBloc(
                            context.read<AuthenticationBloc>().userRepository
                          )
                        ),
                      ],
                      child: const UserScreen(),
                    );
                  }, 
                ),
              );
            },
            icon: const Icon(CupertinoIcons.person),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute<bool>(
                  builder: (BuildContext context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<MyUserBloc>(
                          create: (context) => MyUserBloc(
                            myUserRepository: context.read<AuthenticationBloc>().userRepository,
                          )..add(GetMyUser(myUserId: context.read<AuthenticationBloc>().state.user!.userId)),
                        ),
                        BlocProvider(
                          create: (context) => GetMovieBloc(
                            FirebaseMovieRepo()
                          )..add(GetMovie())
                        ),
                      ],
                      child: const FavoritesScreen(),
                    );
                  }, 
                ),
              ).then(onGoBack);
            }, 
            icon: const Icon(CupertinoIcons.heart)
          ),
          IconButton(
            onPressed: () {
              _showFilterBottomSheet(context); // Call your bottom sheet function here
            },
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetMovieBloc, GetMovieState>(
          builder: (context, state) {
            if (state is GetMovieSuccess) {
              List<Movie> filteredMovies = state.movies;
              if (selectedCountry != 'None') {
                filteredMovies = filteredMovies.where((movie) => movie.country.split('/').contains(selectedCountry)).toList();                
              }
              if (selectedGenre != 'None') {
                filteredMovies = filteredMovies.where((movie) => movie.genre.split('/').contains(selectedGenre)).toList();                
              }
              if(selectedYearDirection == 'up'){
                filteredMovies.sort((a, b) => a.year.compareTo(b.year));
              }else 
              if(selectedYearDirection == 'down'){
                filteredMovies.sort((a, b) => b.year.compareTo(a.year));
              }

              return MoviesGrid(movies: filteredMovies, onlyFav: false,);
            } else if (state is GetMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text("An error has occured..."),
              );
            }
          },
        ),
      ),
    );
  }
}
