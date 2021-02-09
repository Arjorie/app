import 'package:app/component/decorators/TextStyle.dart';
import 'package:app/models/BillModel.dart';
import 'package:app/models/OrderModel.dart';
import 'package:app/models/PageModel.dart';
import 'package:app/store/OrderStore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

NumberFormat pesoFormat = NumberFormat.currency(locale: "en_PH", symbol: "₱");

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key key,
    @required this.order,
    @required this.orderedDate,
    @required this.statusColor,
    @required this.billStatus,
    @required this.isLoading,
    this.bill,
    this.onCancel,
    this.onServe,
  }) : super(key: key);

  final OrderModel order;
  final BillModel bill;
  final String orderedDate;
  final statusColor;
  final String billStatus;
  final bool isLoading;
  final onCancel;
  final onServe;

  @override
  Widget build(BuildContext context) {
    final int totalItems = order.items.length;
    List<Widget> buttons = [];
    if (this.order.status == 'PENDING' && billStatus == 'Bill Issued') {
      buttons.add(Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Container(
          constraints: BoxConstraints(maxHeight: 35),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: SizedBox(
            height: double.infinity,

            /* Cancel Button */
            child: ElevatedButton(
              style: ButtonStyle(
                shape:
                    MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                  (Set<MaterialState> states) {
                    return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0)); // Use the component's default.
                  },
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.red;
                    return Colors.red; // Use the component's default.
                  },
                ),
              ),
              onPressed: () => {onCancel(order.orderId)},
              child: Text(
                "Cancel Order",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
      ));
    }
    if (order.status == 'CANCELLED' ||
        (order.status == 'SERVED' && billStatus == 'PAID') ||
        order.status == 'COMPLETE') {
      buttons.add(SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Text(
          'No Actions Required',
          textAlign: TextAlign.center,
        ),
      ));
    }
    if (order.status == 'SERVING') {
      buttons.add(Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: SizedBox(
          height: 35,
          child: ElevatedButton(
            onPressed: () => {this.onServe(order.orderId)},
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
            ),
            child: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    "Served",
                    style: TextStyle(fontSize: 16.0),
                  ),
          ),
        ),
      ));
    }
    if (billStatus != 'Paid' &&
        billStatus != 'Unbilled' &&
        order.status != 'CANCELLED' &&
        billStatus != 'Pending') {
      buttons.add(
        Padding(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: SizedBox(
            height: 35,
            child: ElevatedButton(
              onPressed: () {
                OrderStore orderStore =
                    Provider.of<OrderStore>(context, listen: false);
                orderStore.totalPrice = order.totalPrice;
                Navigator.of(context).pushNamed(
                  '/payment',
                  arguments: PageModel(title: 'Payment', message: bill?.billId),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      "Payment",
                      style: TextStyle(fontSize: 16.0),
                    ),
            ),
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/order-summary',
            arguments: PageModel(title: 'Summary', message: '', order: order),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              /* Card Contents */
              Container(
                constraints: BoxConstraints(
                  maxHeight: 140,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order no#: ${order.orderNo.toString()}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$orderedDate',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Table no#: ${order.table.sequence.toString()} with ${order.customerCount.toString()} customer${order.customerCount > 1 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: AppGlobalStyles.darkColor,
                                      ),
                                    ),
                                    Text(
                                      '$totalItems item${totalItems > 1 ? 's' : ''} ordered worth of ${pesoFormat.format(order.totalPrice)}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: AppGlobalStyles.darkColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Chip(
                                      backgroundColor: statusColor.shade400,
                                      avatar: CircleAvatar(
                                        backgroundColor: statusColor.shade800,
                                      ),
                                      label: Text(
                                        billStatus == 'Unbilled'
                                            ? 'No Bill yet'
                                            : billStatus,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              /* Card Action Buttons */
              Container(
                constraints: BoxConstraints(maxHeight: 40, minHeight: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: buttons,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
