import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? type;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefix,
    this.validator,
    this.isPassword = false,
    this.type,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool toggle = true;

  void togglePassword() {
    toggle = !toggle;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      keyboardType: widget.type,
      obscureText: widget.isPassword ? toggle : false,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        labelText: widget.label,
        prefixIcon: widget.prefix,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: togglePassword,
                icon: Icon(
                  toggle ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue,
                ))
            : null,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.teal)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}
