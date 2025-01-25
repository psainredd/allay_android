import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectangularPhoto extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final String imageSrc;

  const RectangularPhoto({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.width = 100.0,
    this.height = 100.0,
    required this.imageSrc
  }) : super(key: key);

  ImageProvider _getSourceBasedImageProvider(String source) {
    if(source.startsWith("http://") || source.startsWith("https://")) {
     return NetworkImage(source);
    } else if (source.startsWith("assets/")) {
     return AssetImage(source);
    } else if(source.isNotEmpty) {
     return FileImage(File(source));
    }
    return const AssetImage('assets/tile_background.png');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration (
        borderRadius: BorderRadius.circular(10.0),
        image: imageSrc.isEmpty ? null: DecorationImage (
          image: _getSourceBasedImageProvider(imageSrc),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}