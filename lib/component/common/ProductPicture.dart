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
      constraints: BoxConstraints(minWidth: double.infinity),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4), topLeft: Radius.circular(4)),
        child: SafeImageFetch(imgSrc: imgSrc),
      ),
    );
  }
}

class SafeImageFetch extends StatelessWidget {
  const SafeImageFetch({
    Key key,
    @required this.imgSrc,
  }) : super(key: key);

  final String imgSrc;

  @override
  Widget build(BuildContext context) {
    Widget img;
    try {
      img = FadeInImage.assetNetwork(
        placeholder: 'assets/logo.png',
        fit: BoxFit.cover,
        image: imgSrc,
      );
      return img;
    } catch (err) {
      return null;
    }
  }
}
