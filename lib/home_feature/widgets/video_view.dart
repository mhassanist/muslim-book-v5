import 'package:base_app/placeholder_skeleton/placeholder_skeleton.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PostVideoView extends StatefulWidget {
  PostVideoView({Key key, @required this.url}) : super(key: key);

  final String url;

  @override
  _PostVideoViewState createState() => _PostVideoViewState();
}

class _PostVideoViewState extends State<PostVideoView> {
  ValueNotifier<ChewieController> _chewieControllers = ValueNotifier(null);
  VideoPlayerController _videosController;

  String get url => widget.url;

  @override
  void didChangeDependencies() async {
    _videosController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    // ..initialize().then((_) => setState(() {}));
    await Future.wait([
      _videosController.initialize(),
    ]);
    _chewieControllers.value = ChewieController(
      videoPlayerController: _videosController,
      aspectRatio: 16 / 9,
      autoInitialize: false,
      errorBuilder: (context, errorMessage) => Center(
        child: Text(
          errorMessage,
        ),
      ),
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _videosController?.pause()?.then((_) {
      _videosController?.dispose();
    });
    //  _videosController.dispose();
    _chewieControllers.value?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _chewieControllers,
      builder: (context, value, child) => _chewieControllers.value == null
          ? const PlaceholderSkeleton()
          : Chewie(
              controller: _chewieControllers.value,
            ),
    );
  }
}
