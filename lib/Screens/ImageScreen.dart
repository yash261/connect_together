import 'package:flutter/material.dart';
class ImageScreen extends StatelessWidget {
  final url;
  ImageScreen({this.url});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: url,
      child: Image.network(url),
    );
  }
}
