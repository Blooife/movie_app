
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:movie_app/screens/home/blocs/bloc/my_user_bloc/my_user_bloc.dart';
import 'package:movie_app/screens/home/views/details_screen.dart';
import 'package:movie_repository/movie_repository.dart';

class MoviesGrid extends StatefulWidget {
  final List<Movie> movies;
  final bool onlyFav;

  const MoviesGrid({Key? key, required this.movies, required this.onlyFav}) : super(key: key);

  @override
  _MoviesGridState createState() => _MoviesGridState();
}

class _MoviesGridState extends State<MoviesGrid> {
  late List<Movie> filteredMovies;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredMovies = widget.movies;            
  }
 
  void _search(String query) {
    setState(() {         
      if (query.isEmpty) {
      filteredMovies = widget.movies;
    } else {
      filteredMovies = widget.onlyFav
              ? filteredMovies.where((movie) => movie.isFav!).toList()
              : filteredMovies;
      filteredMovies = filteredMovies.where((movie) => movie.name.toLowerCase().contains(query.toLowerCase())).toList();}
    });
  }

  void onGoBack(List<Movie> mov){
      setState(() {
        //widget.movies = mov;
        filteredMovies = mov;
      });
  }
  
  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user!.userId;
    context.read<MyUserBloc>().add(
      GetMyUser(myUserId: userId),
    );
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if (state.status == MyUserStatus.success) {
          final user = state.user!;
          for (int i = 0; i < filteredMovies.length; i++) {
            filteredMovies[i].isFav = user.favorites.contains(filteredMovies[i].movieId);
          }        
          filteredMovies = widget.onlyFav
              ? filteredMovies.where((movie) => movie.isFav!).toList()
              : filteredMovies;
          
    return Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        pinned: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: _isSearching ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search by movie name',
          ),
          onChanged: _search,
        ) : null,
        leading: IconButton( 
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
        bottom: _isSearching ? const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        ) : null,
      ),
      SliverPadding(
        padding: const EdgeInsets.all(16.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 9 / 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int i) {
              return Material(
                elevation: 3,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DetailsScreen(
                            filteredMovies[i],
                          ),
                        ),
                      ).then((data){
                        if (data != null && data is List<Movie>) {
                          List<Movie> movies = data;
                          onGoBack(movies);
                      }
                    },);},
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 220, 
                                width: double.infinity, 
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    filteredMovies[i].picture[0],
                                    fit: BoxFit.cover, 
                                  ),
                                ),
                              ),
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 135), 
                                child: Text(
                                '${filteredMovies[i].name} (${filteredMovies[i].year})',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                
                              ),
                            ),)
                          ],
                        ),
                        Positioned(
                          bottom: -2,
                          right:-8,
                          child: IconButton(
                            icon: Icon(
                              filteredMovies[i].isFav! ? Icons.favorite : Icons.favorite_border,
                              color: filteredMovies[i].isFav! ? Colors.red : null,
                            ),
                            onPressed: () {
                              final userId = context.read<AuthenticationBloc>().state.user!.userId;
                              final movieId = filteredMovies[i].movieId;
                              setState(() {
                                filteredMovies[i].isFav = !filteredMovies[i].isFav!;
                                //filteredMovies = widget.movies;
                                
                              });
                              context.read<MyUserBloc>().add(
                                AddFavorite(userId, movieId),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            childCount: filteredMovies.length,
          ),
        ),
      ),
    ],
  ),
);
  }else{
    return const Center(
                child: CircularProgressIndicator(),);
  }
});
  }}
