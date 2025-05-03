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
  TransformationController transformationController =
      TransformationController();

  @override
  void dispose() {
    transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color.fromARGB(150, 0, 0, 0),
        body: GestureDetector(
          onTap: () {},
          onDoubleTap: () {
            transformationController.value = Matrix4.identity();
          },
          child: Center(
            child: InteractiveViewer(
                transformationController: transformationController,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    imageUrl: widget.url,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
