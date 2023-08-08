import 'dart:io';

import 'package:black_coffer/data/categories.dart';
import 'package:black_coffer/models/category.dart';
import 'package:black_coffer/models/video_item.dart';
import 'package:black_coffer/widgets/location_input.dart';
import 'package:black_coffer/widgets/text_input.dart';
import 'package:black_coffer/widgets/video_input.dart';
import 'package:flutter/material.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  TextEditingController _titleCotroller = TextEditingController();
  TextEditingController _descriptionCotroller = TextEditingController();
  bool _isGettingLocation = false;

  var _selectedCategory = categories[Categories.values];

  File? _selectedImage;
  String? _currentAddress;

  void handleVideoSelected(File video) {
    setState(() {
      _selectedImage = video;
    });
  }

  void handleCurrentLocation(String currentAddress) {
    setState(() {
      _currentAddress = currentAddress;
    });
  }

  void _uploadVideo() {
    Navigator.of(context).pop(VideoItem(
        selectedVideo: _selectedImage!,
        category: _selectedCategory!,
        title: _titleCotroller.text,
        description: _descriptionCotroller.text,
        location: _currentAddress!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add The Video'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RecordVideo(onVideoSelected: handleVideoSelected),
              const SizedBox(
                height: 14,
              ),
              TextInputField(
                  textEditingController: _titleCotroller,
                  hintText: 'Enter the title',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 14,
              ),
              TextInputField(
                  textEditingController: _descriptionCotroller,
                  hintText: 'Enter the description',
                  maxLines: 5,
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 14,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                      color: Colors.teal), // Set the border color here
                ),
                child: DropdownButtonFormField(
                  focusColor: Colors.tealAccent,
                  value: _selectedCategory,
                  items: [
                    for (final category in categories.entries)
                      DropdownMenuItem(
                        value: category.value,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(category.value.title),
                          ],
                        ),
                      ),
                    const DropdownMenuItem(
                      value: null,
                      child: Text('Choose category'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              LocationPage(onAddressSelected: handleCurrentLocation),
              const SizedBox(
                height: 40,
              ),
              Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextButton(
                  onPressed: _uploadVideo,
                  child: _isGettingLocation == true
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Post the video",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
