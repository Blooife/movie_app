import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screens/home/blocs/bloc/get_movie_bloc/get_movie_bloc.dart';
import 'package:movie_app/screens/home/views/movies_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);             
            }
        ),
      ),
      body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<GetMovieBloc, GetMovieState>(
      builder: (context, state) {
        if (state is GetMovieSuccess) {
          return MoviesGrid(movies: state.movies, onlyFav: true, );
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


