import 'dart:io';

import 'package:flutter/material.dart';
import 'package:halsogourmet/screens/details/fooddetails.dart';
import 'package:halsogourmet/screens/details/foodvideo.dart';
import 'package:halsogourmet/screens/introscreen/introvideo.dart';
import 'package:halsogourmet/utils/colors.dart';
import 'package:halsogourmet/utils/playvideoyoutube.dart';
import 'package:halsogourmet/utils/style_file.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class WatchVideo extends StatefulWidget {
  final Function? callback;
  final String? url;
  const WatchVideo({
    super.key,
    this.url,
    this.callback,
  });

  @override
  State<WatchVideo> createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 100.h,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              Spacer(),
              IconButton(
                  onPressed: () {
                    widget.callback!(true);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black,
                  )),
            ],
          ),
          SizedBox(
              height: 30.h,
              child: PalyVideoYoutubeScreen(
                url: widget.url!,
              )),
        ],
      ),
    );
  }
}
