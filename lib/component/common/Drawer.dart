import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalStorage localStorage = LocalStorage();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back ${AppGlobalConfig.account.firstName}!',
                    style: TextStyle(
                      fontSize: AppGlobalStyles.headingFontSize,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${AppGlobalConfig.account.username}',
                    style: TextStyle(
                      fontSize: AppGlobalStyles.subtitleFontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.65), BlendMode.overlay),
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              'Orders',
              style: AppGlobalStyles.paragraph,
            ),
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/clipboard-clock-outline.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Pending Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/pending-orders');
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/food-delivered.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Served Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/served-orders');
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/food-on-deliver.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Serving Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/serving-orders');
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/cash-check.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Paid Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/paid-orders');
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/clipboard-remove-outline.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Cancelled Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/cancelled-orders');
            },
          ),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/clipboard-check-outline.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Completed Orders',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/complete-orders');
            },
          ),
          Divider(),
          ListTile(
            leading: SvgPicture.asset(
              'assets/svg/logout.svg',
              color: Colors.black.withOpacity(0.6),
              width: 30,
              height: 30,
            ),
            title: Text(
              'Sign Out',
              style: AppGlobalStyles.subtitle,
            ),
            onTap: () {
              return showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                      title: new Text('Sign out'),
                      content: new Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            localStorage.setString('accessToken', '');
                            Navigator.of(context).pushReplacementNamed(
                              '/login',
                              arguments: PageModel(
                                  title: 'Employee Login',
                                  message: 'This is a message'),
                            );
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
          ),
        ],
      ),
    );
  }
}
