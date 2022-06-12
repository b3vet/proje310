import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/screenSizes.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  const FullScreenVideoPlayer(
    this.videoUrl, {
    Key? key,
  }) : super(key: key);
  final String videoUrl;
  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
      autoInitialize: true,
      autoPlay: true,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _chewieController.pause();
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _chewieController.videoPlayerController.value.isPlaying
                  ? _chewieController.pause()
                  : _chewieController.play();
            });
          },
          child: Icon(
            _chewieController.videoPlayerController.value.isPlaying
                ? Icons.pause
                : Icons.play_arrow,
          ),
        ),
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}

class PostVideoPlayer extends StatefulWidget {
  const PostVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);
  final String videoUrl;

  @override
  State<PostVideoPlayer> createState() => _PostVideoPlayerState();
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  Future<String> getFileName(String videoUrl) async {
    final filename = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      thumbnailPath: (await getTemporaryDirectory()).path,
      maxWidth: 0,
      quality: 100,
    );
    return filename!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getFileName(widget.videoUrl),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 250),
                  pageBuilder: (context, _, __) =>
                      FullScreenVideoPlayer(widget.videoUrl),
                ),
              ),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: snapshot.hasData
                          ? Image.file(
                              File(
                                snapshot.data,
                              ),
                              height: screenHeight(context, dividedBy: 4),
                              fit: BoxFit.cover,
                            )
                          : SizedBox(
                              height: screenHeight(context, dividedBy: 4),
                            ),
                    ),
                    Positioned(
                      left: 170,
                      top: 90,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
