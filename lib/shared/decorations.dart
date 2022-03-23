import 'package:flutter/material.dart';

var textinputdecoration = InputDecoration(
  fillColor: Colors.green,
  filled: true,
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(color: Colors.red, width: 2)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
  ),
);
