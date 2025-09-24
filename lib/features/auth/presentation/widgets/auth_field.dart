import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isObscureText;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isObscureText,
      controller: widget.controller,
      decoration: InputDecoration(hintText: widget.hintText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.hintText;
        }
        return null;
      },
    );
  }
}
