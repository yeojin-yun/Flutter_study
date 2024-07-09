import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

class UserService {
  final http.Client httpClient;

  UserService(this.httpClient);
  Future<Map<String, dynamic>> fetchUserInfo(String userId) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
