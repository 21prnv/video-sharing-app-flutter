import 'package:flutter/material.dart';

enum Categories {
  music,
  sports,
  gaming,
  technology,
  fashion,
  cooking,
  travel,
  education,
  comedy,
  animals
}

class Category {
  const Category(
    this.title,
  );

  final String title;
}
