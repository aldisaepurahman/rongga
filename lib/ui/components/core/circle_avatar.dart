import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircleAvatarCustom extends StatefulWidget {
  final File? image;
  final String? fromNetwork;
  final String? path;
  final Uint8List? webPreview;
  final double radius;
  final bool isWeb;

  const CircleAvatarCustom(
      {super.key, this.image, required this.radius, this.path, this.fromNetwork, required this.isWeb, this.webPreview});

  @override
  State<StatefulWidget> createState() => _CircleAvatarCustom();
}

class _CircleAvatarCustom extends State<CircleAvatarCustom> {
  @override
  Widget build(BuildContext context) {
    print((widget.fromNetwork != null && widget.fromNetwork!.isNotEmpty) ? widget.fromNetwork! : "");

    return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: widget.radius,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: widget.radius-2,
        child: ClipOval(
          child: (widget.isWeb && widget.webPreview != null)
              ? Image.memory(widget.webPreview!)
              :(widget.image != null) ? Image.file(widget.image!)
              : (widget.fromNetwork != null && widget.fromNetwork!.isNotEmpty)
              ? Image.network("http://localhost:3000/public/images/${widget.fromNetwork!}") : Image.asset(widget.path!),
        ),
      ),
    );
  }

}