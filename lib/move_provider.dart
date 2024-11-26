import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieProvider extends ChangeNotifier {
  List<dynamic> _movies = [];
  bool _isLoading = false;

  List<dynamic> get movies => _movies;
  bool get isLoading => _isLoading;

  // Function to fetch initial data when app loads
  Future<void> fetchInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://api.tvmaze.com/shows');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _movies = data.take(5).toList(); // Take only first 5 items for initial display
      } else {
        _movies = [];
      }
    } catch (error) {
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to search movies based on query
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _movies = data.map((item) => item['show']).toList();
      } else {
        _movies = [];
      }
    } catch (error) {
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
