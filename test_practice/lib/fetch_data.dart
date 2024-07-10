import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({required this.userId, required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

class ApiService {
  final Dio dio;

  ApiService({required this.dio});

  Future<Album> fetchAlbum() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/albums/1');
    if (response.statusCode == 200) {
      return Album.fromJson(response.data);
    } else {
      // throw Exception('Failed to load album');
      debugPrint('statement');
      throw Exception('failed');
    }
  }
}
