import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoId; // YouTube video ID

  const YouTubeVideoPlayer({super.key, required this.videoId});

  @override
  _YouTubeVideoPlayerState createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    print('🎥 Initializing YouTube player with video ID: ${widget.videoId}');
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void didUpdateWidget(YouTubeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      print('Video ID changed from ${oldWidget.videoId} to ${widget.videoId}');
      _controller.load(widget.videoId);
    }
  }

  @override
  void dispose() {
    print('🎥 Disposing YouTube player for video ID: ${widget.videoId}');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false, // Disable the progress indicator
        progressIndicatorColor: Colors.transparent, // Set to transparent
        onReady: () {
          print('🎥 Player is ready for video ID: ${widget.videoId}');
        },
        onEnded: (data) {
          print('Video ended for video ID: ${widget.videoId}');
        },
      
      ),
    );
  }
}
