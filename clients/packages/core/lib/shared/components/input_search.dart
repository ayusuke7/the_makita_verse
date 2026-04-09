import 'package:flutter/material.dart';

class InputSearch extends StatelessWidget {
  final TextEditingController controller;
  final EdgeInsets padding;

  final Function(String)? onChanged;
  final Function()? onClear;

  final String? hintText;
  final bool isClear;

  const InputSearch({
    super.key,
    this.onChanged,
    this.onClear,
    this.hintText,
    this.isClear = false,
    this.padding = const EdgeInsets.all(20),
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          suffixIcon: isClear
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: onClear,
                )
              : Icon(Icons.search),
        ),
      ),
    );
  }
}
