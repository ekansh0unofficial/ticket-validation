import 'dart:convert';

import 'package:advaita_ticket_validator/utilities/user_type.dart';
import 'package:http/http.dart' as http;

class Authenticator {
  Future<String> welcome(String s) async {
    final url = Uri.parse(
      'https://advaita25-ticket-backend.vercel.app/authenticator/validate_code?code=$s',
    );

    // Retrieve Auth Token
    final token = await SharedPrefHelper.getAuthToken();
    if (token.isEmpty) {
      print("Error: Auth Token is missing");
      return "Error: Auth Token is missing";
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    print("Sending Request to: $url");
    print("Headers: $headers");

    try {
      final response = await http.post(url, headers: headers);
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data['message'] ?? "");
        return data['message'];
      } else if (response.statusCode == 422) {
        return 'Error 422: Unprocessable Entity - Check request data';
      } else {
        return 'Client/Server Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error in Authentication: $e';
    }
  }
}
