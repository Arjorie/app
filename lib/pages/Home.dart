import 'package:app/component/common/ContainerWithBlurBackground.dart';
import 'package:app/component/common/MenuButton.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> top = [];
  List<int> bottom = [0];

  // initState()
  // - on create/init hook/method of this class
  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    // usernameTFController.addListener(_printLatestValue);
  }

  Future<bool> onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Quit App'),
            content: new Text('Do you want to exit App?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
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
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('bottom-sliver-list');

    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Drawer Header'),
                  decoration: BoxDecoration(
                    color: Colors.primaries[0],
                  ),
                ),
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                  expandedHeight: 120.0,
                  floating: true,
                  snap: true,
                  leading: MenuButton(),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text('Dashboard'),
                    background:
                        ContainerWithBlurBackground(contentWidget: null),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      tooltip: 'Add new entry',
                      onPressed: () {
                        setState(() {
                          top.add(-top.length - 1);
                          bottom.add(bottom.length);
                        });
                      },
                    ),
                  ]),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.blue[200 + top[index] % 4 * 100],
                      height: 100 + top[index] % 4 * 20.0,
                      child: Text('Item: ${top[index]}'),
                    );
                  },
                  childCount: top.length,
                ),
              ),
              SliverList(
                key: centerKey,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.blue[200 + bottom[index] % 4 * 100],
                      height: 100 + bottom[index] % 4 * 20.0,
                      child: Text('Item: ${bottom[index]}'),
                    );
                  },
                  childCount: bottom.length,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton.extended(
            label: Text(
              'Take Order',
              style: TextStyle(color: Colors.white),
            ),
            // backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pushNamed(context, '/select-table');
            },
          ),
        ));
  }
}
