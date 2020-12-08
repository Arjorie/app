import 'package:flutter/material.dart';

class ProductPicture extends StatelessWidget {
  final double width;
  final double height;
  final String imgSrc;
  const ProductPicture({
    Key key,
    this.width,
    this.height,
    this.imgSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        // borderRadius: BorderRadius.all(Radius.circular(4)),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4), topLeft: Radius.circular(4)),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/logo.png',
          fit: BoxFit.cover,
          image: imgSrc,
        ),
      ),
    );
  }
}
