import 'dart:convert';

import 'package:advaita_ticket_validator/utilities/user_type.dart';
import 'package:http/http.dart' as http;

class Validator {
  Future<String> create(String s) async {
    final url = Uri.parse(
      'https://advaita25-ticket-backend.vercel.app/validator/add_code',
    );
    final token = await SharedPrefHelper.getAuthToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'code': s, 'validated_status': false});
    print("$body\n $url");
    try {
      final response = await http.post(url, headers: headers, body: body);
      print('response: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('validating');
        final data = jsonDecode(response.body);
        return data['message'];
      } else {
        print("failed");
        return 'Failed';
      }
    } catch (e) {
      print("Error : $e");
      return "Client/Server Error";
    }
  }
}
