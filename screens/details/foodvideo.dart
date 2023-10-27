import 'package:chewie/chewie.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class FoodVideo extends StatefulWidget {
  const FoodVideo({super.key});

  @override
  State<FoodVideo> createState() => _FoodVideoState();
}

class _FoodVideoState extends State<FoodVideo> {
  late VideoPlayerController videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    videoPlayerController = VideoPlayerController.network(
        //'https://youtu.be/sC124g6CSn8');

        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    super.initState();
  }

  videoload() async {
    await videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        allowFullScreen: false,
      ),
    );
  }
}
