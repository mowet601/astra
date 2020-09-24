import 'package:astra/screens/chatscreens/cached_image.dart';
import 'package:astra/utils/universal_variables.dart';
import "package:flutter/material.dart";
import 'package:vector_math/vector_math_64.dart' show Vector3;

class FullImageScreen extends StatefulWidget {
  static const routeName = "/full-image-screen";
  final String url;
  FullImageScreen(this.url);

  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          print(details);
          _previousScale = _scale;
          setState(() {});
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          print(details);
          _scale = _previousScale * details.scale;
          setState(() {});
        },
        onScaleEnd: (ScaleEndDetails details) {
          print(details);

          _previousScale = 1.0;
          setState(() {});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
              child: Container(
                  width: double.infinity,
                  child: Hero(
                    tag: widget.url,
                    child: CachedImage(
                      widget.url,
                      width: 250,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
