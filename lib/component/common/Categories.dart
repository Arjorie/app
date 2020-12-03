import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final imgSrc;
  final text;

  const CategoryCard({
    Key key,
    @required this.imgSrc,
    @required this.text,
  }) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 4,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          onTap: () => {},
          child: Container(
            height: 100,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.65), BlendMode.overlay),
                image: AssetImage(widget.imgSrc),
                fit: BoxFit.cover,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                widget.text,
                style: TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.4),
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
