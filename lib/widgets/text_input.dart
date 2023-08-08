import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.isPass = false,
      this.maxLines,
      required this.textInputType});

  final TextEditingController textEditingController;
  final String hintText;
  final bool isPass;
  final TextInputType textInputType;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    final inputFiledBorder =
        OutlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent));
    return TextField(
      controller: textEditingController,
      style: TextStyle(color: Colors.blue),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.teal),
          border: inputFiledBorder,
          focusedBorder: inputFiledBorder,
          enabledBorder: inputFiledBorder,
          filled: false,
          contentPadding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5)),
      keyboardType: textInputType,
      maxLines: maxLines,
      obscureText: isPass,
    );
  }
}
