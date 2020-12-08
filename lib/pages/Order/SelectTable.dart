import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:app/component/common/AlertDialog.dart';
import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/config.dart';
import 'package:app/helpers/Storage.dart';
import 'package:app/models/PageModel.dart';

class SelectTable extends StatefulWidget {
  @override
  _SelectTableState createState() => _SelectTableState();
}

class _SelectTableState extends State<SelectTable> {
  // ignore: slash_for_doc_comments
  /**
   * Page Data
   */
  bool isLoading = true;
  BuildContext appContext;
  final LocalStorage localStorage = LocalStorage();
  List<dynamic> tables = [];

  // initState()
  // - on create/init hook/method of this class
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 200), () async => {this.getTableData()});
  }

  // ignore: slash_for_doc_comments
  /**
   * Page Methods
   */
  /* Retrieve table data */
  Future getTableData() async {
    print(AppGlobalConfig.server);
    final String token = await localStorage.getString('accessToken');
    final String authorizationHeader = 'Basic $token';
    final response = await http.get(
      '${AppGlobalConfig.server}/employee/v1/tables',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorizationHeader,
      },
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      setState(() {
        tables = result['data'];
      });
    } else if (response.statusCode == 403) {
      showAlertDialog(appContext, 'Session Expired!', 'Please relogin!');
      Navigator.of(appContext).pushReplacementNamed(
        '/login',
        arguments:
            PageModel(title: 'Employee Login', message: 'This is a message'),
      );
    } else {
      showAlertDialog(appContext, 'Ooops!', 'Something went wrong!');
    }
  }

  void gotoProducts(tableId) {
    AppGlobalConfig.orders.tableId = tableId;
    Navigator.of(appContext).pushNamed(
      '/order-products',
    );
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    CircularProgressIndicator progressCircle = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Select table to serve'),
      ),
      body: Center(
        child: isLoading == true
            ? progressCircle
            : ListView.builder(
                itemCount: tables.length != null ? tables.length : 0,
                itemBuilder: (context, index) {
                  final String tableSequence =
                      tables[index]['sequence'].toString();
                  final String tableChairs =
                      tables[index]['chairs']?.toString();
                  final String tableColor =
                      tables[index]['color']?.toString()?.toUpperCase();
                  final String tableShape =
                      tables[index]['shape']?.toString()?.toUpperCase();
                  final String tableId = tables[index]['table_id'];
                  List<Widget> tableWidgets = [];
                  if (tableSequence != null)
                    tableWidgets.add(Text('Table #$tableSequence',
                        style: AppGlobalStyles.boldTitle));
                  if (tableChairs != null)
                    tableWidgets.add(Text('Chairs: $tableChairs',
                        style: AppGlobalStyles.subtitle));
                  if (tableShape != null)
                    tableWidgets.add(Text('Shape: $tableShape',
                        style: AppGlobalStyles.subtitle));
                  if (tableColor != null)
                    tableWidgets.add(Text('Color: $tableColor',
                        style: AppGlobalStyles.subtitle));

                  return Card(
                    child: InkWell(
                      onTap: () => {gotoProducts(tableId)},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/svg/table-chair-colored.svg',
                                width: 80,
                                height: 70,
                                // color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: tableWidgets,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 80,
                              child: Icon(Icons.keyboard_arrow_right),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
