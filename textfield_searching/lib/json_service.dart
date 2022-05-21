import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IJsonService {
  Future<List<dynamic>> getAllUser();
}

class JsonService extends IJsonService {
  final String BASE_URL = "https://jsonplaceholder.typicode.com";

  @override
  Future<List<dynamic>> getAllUser() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/users"));
      return json.decode(response.body);
    } catch (e) {
      print(e);
      return [];
    }
  }
}
