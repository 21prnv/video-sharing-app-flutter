import 'dart:io';

import 'package:black_coffer/models/category.dart';

class VideoItem {
  final File selectedVideo;
  final String title;
  final String description;
  final String location;
  final Category category;

  VideoItem({
    required this.selectedVideo,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
  });
}
