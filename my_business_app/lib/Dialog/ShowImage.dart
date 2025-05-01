import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatefulWidget {
  String url;
  ShowImage({super.key, required this.url});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.transparent,
        content: InteractiveViewer(
            child: CachedNetworkImage(
          imageUrl: widget.url,
        )));
  }
}
