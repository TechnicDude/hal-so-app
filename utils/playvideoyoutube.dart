import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PalyVideoYoutubeScreen extends StatefulWidget {
  final String url;
  PalyVideoYoutubeScreen({
    super.key,
    required this.url,
  });

  @override
  State<PalyVideoYoutubeScreen> createState() => _PalyVideoYoutubeScreenState();
}

class _PalyVideoYoutubeScreenState extends State<PalyVideoYoutubeScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  @override
  void initState() {
    // TODO: implement initState
    _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.url).toString(),
        flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            showLiveFullscreenButton: false))
      ..addListener(listener);
    _playerState = PlayerState.unknown;
    _videoMetaData = const YoutubeMetaData();

    super.initState();
    print(widget.url);
  }

  bool fullscreen = false;
  void listener() {
    if (_isPlayerReady && mounted && fullscreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return YoutubePlayer(
    //   controller: _controller,
    //   liveUIColor: Colors.amber,
    //   onReady: () {
    //     _isPlayerReady = true;
    //   },
    // );
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        fullscreen = true;
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        liveUIColor: Colors.amber,
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50), child: AppBarScreens()),
          body: player,
        );
      },
    );
  }
}
