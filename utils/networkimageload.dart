import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:halsogourmet/utils/loaderscreen.dart';

class NetWorkImageScreen extends StatefulWidget {
  final String image;
  final double? height;
  const NetWorkImageScreen({super.key, required this.image, this.height});

  @override
  State<NetWorkImageScreen> createState() => _NetWorkImageScreenState();
}

class _NetWorkImageScreenState extends State<NetWorkImageScreen> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: widget.height,
      width: widget.height,
      imageUrl: widget.image,
      fit: BoxFit.cover,
      placeholder: (context, url) => LoaderScreen(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
