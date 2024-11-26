import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'move_provider.dart';


class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context);

    // Fetch initial data when the app loads
    if (provider.movies.isEmpty && !provider.isLoading) {
      provider.fetchInitialData();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('AI & Movie Search', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF5EC570),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Box
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (query) => provider.searchMovies(query),
                decoration: InputDecoration(
                  hintText: 'Search Movies...',
                  hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0, color: Colors.grey),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0),
              ),
            ),
            SizedBox(height: 16.0),

            // Display loading indicator while fetching data
            if (provider.isLoading)
              Center(child: CircularProgressIndicator())
            else if (provider.movies.isEmpty)
              Center(child: Text('No movies found.', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0)))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: provider.movies.length,
                  itemBuilder: (ctx, index) {
                    final movie = provider.movies[index];
                    return MovieCard(movie: movie);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Movie Poster
            if (movie['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  movie['image']['medium'],
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(width: 80, height: 120, color: Colors.grey.shade300), // Placeholder for missing image

            SizedBox(width: 16.0),

            // Movie Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['name'] ?? 'No Title',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                    overflow: TextOverflow.ellipsis, // Ensures the title doesn't overflow
                    maxLines: 1, // Limits title to 1 line
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    movie['genres']?.join(', ') ?? 'No genres available',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.grey),
                    overflow: TextOverflow.ellipsis, // Ensures genres text doesn't overflow
                    maxLines: 1, // Limits genres to 1 line
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movie['rating']['average']?.toString() ?? 'N/A',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
