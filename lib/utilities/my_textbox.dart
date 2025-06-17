import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextfield extends StatefulWidget {
  bool obscure;
  final String hintText;
  final String label;
  bool? icon;
  TextEditingController controller;

  MyTextfield(
    this.controller, {
    super.key,
    required this.label,
    this.hintText = "",
    this.obscure = false,
    this.icon,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode, // Attach focus node
        textAlign: TextAlign.center,
        obscureText: widget.obscure,
        decoration: InputDecoration(
          labelText:
              _isFocused || widget.controller.text.isNotEmpty
                  ? null
                  : widget.label, // Hide label when focused
          labelStyle: TextStyle(color: Colors.grey[800]),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white), // White border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
            ), // White border on focus
          ),
          suffixIcon:
              widget.icon == true
                  ? IconButton(
                    icon:
                        widget.obscure
                            ? const Icon(Icons.visibility_rounded)
                            : const Icon(Icons.visibility_off_rounded),
                    onPressed: () {
                      setState(() {
                        widget.obscure = !widget.obscure;
                      });
                    },
                  )
                  : null,
        ),
        cursorColor: Colors.grey[600],
      ),
    );
  }
}
