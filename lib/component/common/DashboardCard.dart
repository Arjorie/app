import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.color,
    @required this.text,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String text;
  final String icon;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                constraints: BoxConstraints(
                  minHeight: 180,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: SvgPicture.asset(
                        icon,
                        color: color,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Text(text,
                        style: TextStyle(
                          fontSize: 40,
                          color: color,
                          fontWeight: FontWeight.bold,
                        )),
                    Divider(),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
