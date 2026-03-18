import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageNumberButton extends StatefulWidget {
  final String normalImageName;
  final Widget chageImage;
  final int number;
  final VoidCallback onPressed;

  ImageNumberButton({
    required Key key,
    required this.normalImageName,
    required this.chageImage,
    required this.number,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageNumberButtonState();
  }
}

class _ImageNumberButtonState extends State<ImageNumberButton> {
  bool isClicked = false;
  int count = 0;
  @override
  void initState() {
    super.initState();
    count = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isClicked = !isClicked;
          if (isClicked) {
            count += 1;
          } else if (count > 0 && !isClicked) {
            count -= 1;
          }
          widget.onPressed();
        });
      },
      child: Column(
        crossAxisAlignment: .center,
        children: [
          image(isClicked, widget.normalImageName, widget.chageImage),
          Text(
            "${count}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget image(bool isClicked, String normalImagePath, Widget changedWidget) {
  if (isClicked) {
    return changedWidget;
  } else {
    return Image.asset(
      normalImagePath,
      fit: BoxFit.cover,
      width: 25,
      height: 25,
    );
  }
}
