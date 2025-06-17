import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyAlertbox extends StatelessWidget {
  final String? message;
  final String title;
  final IconData icon;
  final Color iconColor;

  MyAlertbox({
    super.key,
    this.message,
    this.title = "Error",
    this.icon = Icons.error,
    this.iconColor = const Color.fromARGB(146, 244, 67, 54),
  });

  final Map<String, int> map = {
    'Duplicate code': 1,
    'Code added successfully': 2,
    'Invalid code': 3,
    'Code already validated before': 4,
    'Code validated successfully': 5,
  };

  @override
  Widget build(BuildContext context) {
    int? messageType = map[message];

    String newTitle = "Error";
    Color newColor = const Color.fromARGB(255, 189, 44, 33);
    String newContent = message ?? "An unknown error occurred.";

    switch (messageType) {
      case 2:
        newTitle = "Success";
        newColor = const Color.fromARGB(255, 52, 147, 57);
        newContent = "New code added";
        break;
      case 5:
        newTitle = "Success";
        newColor = const Color.fromARGB(255, 52, 147, 57);
        newContent = "Welcome to Advaita";
        break;
      case 3:
      case 4:
        newTitle = "Error";
        newColor = const Color.fromARGB(255, 189, 44, 33);
        break;
      case 1:
        newTitle = "Warning";
        newColor = const Color.fromARGB(255, 185, 141, 6);
        break;
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 16.0),
      title: Container(
        decoration: BoxDecoration(
          color: newColor.withOpacity(0.2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: newColor, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                newTitle,
                style: TextStyle(
                  color: newColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            newContent,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
