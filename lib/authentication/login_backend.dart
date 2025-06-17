import 'dart:convert';
import 'package:advaita_ticket_validator/scanner/scanner.dart';
import 'package:advaita_ticket_validator/utilities/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginViewModel extends ChangeNotifier {
  bool _loading = false;
  final _storage = const FlutterSecureStorage();

  bool get isLoading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<String?> loadToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> logout(BuildContext context) async {
    await _storage.delete(key: 'token'); // Remove saved token
    notifyListeners();
  }

  Future<void> loginUser(Map<String, String> user, BuildContext context) async {
    setLoading(true);

    final String username = user['username']!;
    final String password = user['password']!;

    final Uri url = Uri.parse(
      'https://advaita25-ticket-backend.vercel.app/login',
    );
    print('URL: $url');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final body = {'username': username, 'password': password};
    print('body: $body');
    try {
      print('in try block ');
      final http.Response response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      print('request hit');
      if (response.statusCode == 200) {
        print('200');
        final Map<String, dynamic> data = json.decode(response.body);

        print('data: $data');
        final String token = data['access_token'];
        await SharedPrefHelper.setAuthToken(token);
        await SharedPrefHelper.setUserType(data['role']);
        await _storage.write(key: 'token', value: token);
        setLoading(false);

        Fluttertoast.showToast(
          msg: 'User logged in successfully!',
          toastLength: Toast.LENGTH_SHORT,
        );

        // Navigate to Scanner screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Scanner()),
        );
      } else {
        print(response.statusCode);
        setLoading(false);
        _handleError(response);
      }
    } catch (e) {
      setLoading(false);
      print('Error');
      Fluttertoast.showToast(
        msg: 'Network error: $e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _handleError(http.Response response) {
    String errorMsg = 'Login failed';

    try {
      final Map<String, dynamic> errorData = json.decode(response.body);
      errorMsg = errorData['message'] ?? errorMsg;
    } catch (e) {
      errorMsg = response.body.isNotEmpty ? response.body : errorMsg;
    }

    Fluttertoast.showToast(msg: errorMsg, toastLength: Toast.LENGTH_LONG);
  }
}
