import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_venteny_app/bloc/video_block.dart';
import 'package:test_venteny_app/models/video_model.dart';
import 'package:test_venteny_app/screens/video_player_screen.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage({super.key});

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  String _searchQuery = '';
  bool _isSearching = false;

  Future<void> _refreshVideos(BuildContext context) async {
    context.read<VideoBloc>().add(FetchVideos());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc()..add(FetchVideos()),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Movie',
              style: TextStyle(
                fontSize: 44,
                color: const Color.fromARGB(255, 248, 3, 3),
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(3.0, 3.0),
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8.0,
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.black,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue.withOpacity(0.9),
                  Colors.blueAccent.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = '';
                  }
                });
              },
            ),
          ],
          elevation: 8,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue.withOpacity(0.9),
                Colors.blueAccent.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: BlocBuilder<VideoBloc, VideoState>(
            builder: (context, state) {
              if (state is VideoLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is VideoLoaded) {
                final filteredVideos = state.videos.where((video) {
                  return video.title.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                return Column(
                  children: [
                    if (_isSearching)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: TextField(
                          onChanged: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: const TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[800],
                            contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _refreshVideos(context),
                        child: ListView.builder(
                          itemCount: filteredVideos.length,
                          itemBuilder: (context, index) {
                            VideoModel video = filteredVideos[index];
                            if (kDebugMode) {
                              print("Loading video URL: ${video.videoUrl}");
                            }

                            return Card(
                              color: Colors.grey[900],
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: video.thumbnailUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        'assets/images/placeholder_photo.png',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                title: Text(
                                  video.title,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${video.views} views • ${video.duration}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                onTap: () {
                                  if (kDebugMode) {
                                    print("Navigating to video: ${video.videoUrl}");
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoPlayerPage(videoUrl: video.videoUrl, title: video.title),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is VideoError) {
                return const Center(child: Text('Failed to load videos', style: TextStyle(color: Colors.white)));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}