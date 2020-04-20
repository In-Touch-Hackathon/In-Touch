import 'package:flutter/material.dart';

Widget entryField(
    String title, {
      void Function(String) onSaved,
      String Function(String) validator,
      bool isPassword = false,
    }) {
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: 10,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          onSaved: (
              value,
              ) {
            onSaved(
              value,
            );
          },
          validator: validator ?? (value) => null,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.black26,
            filled: true,
          ),
        )
      ],
    ),
  );
}
