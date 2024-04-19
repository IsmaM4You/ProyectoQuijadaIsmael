import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://your-api.com/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final accessToken = json.decode(response.body)['access_token'] as String;
      await _storeAccessToken(accessToken);
      return accessToken;
    } else {
      return null;
    }
  }

  Future<String?> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://your-api.com/register'),
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final accessToken = json.decode(response.body)['access_token'] as String;
      await _storeAccessToken(accessToken);
      return accessToken;
    } else {
      return null;
    }
  }

  Future<void> _storeAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}