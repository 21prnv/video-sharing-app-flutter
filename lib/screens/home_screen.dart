import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:black_coffer/models/video_item.dart';
import 'package:black_coffer/screens/upload_video.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<VideoPlayerController?> _videoPlayerControllers = [];
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVideoPlaying = false;
  List<VideoItem> _newGroceryList = [];
  String _searchQuery = '';

  void _additem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const UploadVideo()),
    );
    if (newItem == null) {
      return;
    }
    final controller = VideoPlayerController.file(newItem.selectedVideo);
    _videoPlayerControllers.add(controller);
    _initializeVideoPlayerFuture = controller.initialize();
    setState(() {
      _newGroceryList.add(newItem);
    });
  }

  @override
  void dispose() {
    for (var controller in _videoPlayerControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  List<VideoItem> _getFilteredVideos() {
    return _newGroceryList.where((video) {
      final title = video.title.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Oops..nothing is here :)'),
    );

    final List<VideoItem> filteredVideos = _getFilteredVideos();
    print(filteredVideos.length);

    if (filteredVideos.isNotEmpty) {
      content = Expanded(
        child: ListView.builder(
          itemCount: filteredVideos.length,
          itemBuilder: (context, index) {
            if (_videoPlayerControllers[index] != null) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_videoPlayerControllers[index] != null)
                              FutureBuilder(
                                future: _initializeVideoPlayerFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return SizedBox(
                                      width: double.maxFinite,
                                      height: _videoPlayerControllers[index]!
                                          .value
                                          .size
                                          .height,
                                      child: VideoPlayer(
                                          _videoPlayerControllers[index]!),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            if (_videoPlayerControllers[index] != null &&
                                !_isVideoPlaying)
                              IconButton(
                                icon: Icon(Icons.play_arrow),
                                onPressed: () {
                                  setState(() {
                                    _videoPlayerControllers[index]!.play();
                                    _isVideoPlaying = true;
                                  });
                                },
                              ),
                            if (_videoPlayerControllers[index] != null &&
                                _isVideoPlaying)
                              IconButton(
                                icon: Icon(Icons.pause),
                                onPressed: () {
                                  setState(() {
                                    _videoPlayerControllers[index]!.pause();
                                    _isVideoPlaying = false;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredVideos[index].title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredVideos[index].description,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredVideos[index].location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            filteredVideos[index].category.title,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Videos List'),
        actions: [
          IconButton(onPressed: _additem, icon: Icon(Icons.add_a_photo)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          content,
        ],
      ),
    );
  }
}
