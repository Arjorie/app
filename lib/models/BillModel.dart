// Bill Model
import 'package:app/models/PaymentOptionModel.dart';
import 'package:flutter/material.dart';

class BillModel {
  String billId;
  double totalAmount;
  double amountPaid;
  double changeAmount;
  String accountNumber;
  String accountName;
  PaymentOptionModel paymentOption;
  String status;

  BillModel({
    this.billId,
    this.totalAmount,
    this.amountPaid,
    this.changeAmount,
    this.accountNumber,
    this.accountName,
    this.paymentOption,
    this.status,
  });

  static String getStatus(val) {
    Map<String, dynamic> status = {
      'BILL_ISSUED': 'Bill Issued',
      'PAID': 'Paid',
      'PENDING': 'Pending',
      'REFUNDED': 'Refunded'
    };
    return status[val];
  }

  static getStatusColor(val) {
    Map<String, dynamic> status = {
      'BILL_ISSUED': Colors.blue,
      'PAID': Colors.green,
      'PENDING': Colors.orange,
      'REFUNDED': Colors.purple,
    };
    return status[val];
  }

  factory BillModel.fromJson(Map<String, dynamic> bill) {
    if (bill != null) {
      return BillModel(
        billId: bill['bill_id'],
        totalAmount: bill['total_amount'].toDouble(),
        amountPaid: bill['amount_paid'].toDouble(),
        changeAmount: bill['change_amount'].toDouble(),
        accountNumber: bill['account_number'],
        accountName: bill['account_name'],
        paymentOption: PaymentOptionModel.fromJson(bill['payment_option']),
        status: bill['status'],
      );
    }
    return null;
  }
}
