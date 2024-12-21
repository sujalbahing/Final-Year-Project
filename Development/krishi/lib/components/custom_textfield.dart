import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType inputType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Icon? suffixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.suffixIcon, // Optional suffix icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320, // Set desired width here
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xff82828282),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
          suffixIcon: suffixIcon, // Add the suffix icon here
        ),
      ),
    );
  }
}
