import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key, required this.onVideoSelected});
  final void Function(File video) onVideoSelected;
  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  File? _selectedImage;
  VideoPlayerController? _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoPlaying = false;

  void _takePicture() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickVideo(
      source: ImageSource.camera,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
      _videoPlayerController = VideoPlayerController.file(_selectedImage!);
      _initializeVideoPlayerFuture = _videoPlayerController!.initialize();
      _videoPlayerController!.setLooping(true);
      _videoPlayerController!.play();
      _isVideoPlaying = true;
    });
    widget.onVideoSelected(_selectedImage!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_videoPlayerController != null)
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox(
                      width: double.maxFinite,
                      height: _videoPlayerController!.value.size.height,
                      child: VideoPlayer(_videoPlayerController!),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            if (_videoPlayerController == null && _selectedImage == null)
              TextButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Record a video'),
                onPressed: _takePicture,
              ),
            if (_videoPlayerController != null && !_isVideoPlaying)
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    _videoPlayerController!.play();
                    _isVideoPlaying = true;
                  });
                },
              ),
            if (_videoPlayerController != null && _isVideoPlaying)
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  setState(() {
                    _videoPlayerController!.pause();
                    _isVideoPlaying = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
