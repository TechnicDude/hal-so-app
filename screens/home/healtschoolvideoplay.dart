import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halsogourmet/model/healthschoolmodel.dart';
import 'package:halsogourmet/screens/home/sliderscreen.dart';

import 'package:halsogourmet/utils/appbarforall.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/playvideoyoutube.dart';
import 'package:halsogourmet/utils/videoslider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HealthSchoolVideoPlay extends StatefulWidget {
  final HealthschoolData healthschooldata;

  HealthSchoolVideoPlay({super.key, required this.healthschooldata});

  @override
  State<HealthSchoolVideoPlay> createState() => _HealthSchoolVideoPlayState();
}

class _HealthSchoolVideoPlayState extends State<HealthSchoolVideoPlay> {
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    return PalyVideoYoutubeScreen(
      url: widget.healthschooldata.videoUrl.toString(),
    );
    // return WillPopScope(
    //   onWillPop: () async {
    //     return shouldPop;
    //   },
    //   child: OrientationBuilder(
    //       builder: (BuildContext context, Orientation orientation) {
    //     if (orientation == Orientation.landscape) {
    //       return Scaffold(
    //         body: PalyVideoYoutubeScreen(
    //           url: widget.healthschooldata.videoUrl.toString(),
    //         ),
    //       );
    //     } else {
    //       return PalyVideoYoutubeScreen(
    //         url: widget.healthschooldata.videoUrl.toString(),
    //       );
    //     }
    //   }),
    // );
    // return Scaffold(
    //   appBar: PreferredSize(
    //       preferredSize: Size.fromHeight(50), child: AppBarScreens()),
    //   body: PalyVideoYoutubeScreen(
    //     url: widget.healthschooldata.videoUrl.toString(),
    //   ),
    // );
  }
}
