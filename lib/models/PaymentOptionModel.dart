class PaymentOptionModel {
  String paymentOptionId;
  String name;
  String accountName;
  String accountNumber;
  String description;

  PaymentOptionModel({
    this.paymentOptionId,
    this.name,
    this.accountName,
    this.accountNumber,
    this.description,
  });

  static List<PaymentOptionModel> fromArray(List<dynamic> payments) {
    List<PaymentOptionModel> paymentOptions = [];
    payments
        .map((payment) =>
            {paymentOptions.add(PaymentOptionModel.fromJson(payment))})
        .toList();
    return paymentOptions;
  }

  factory PaymentOptionModel.fromJson(Map<String, dynamic> payment) {
    return PaymentOptionModel(
      accountName: payment['account_name'],
      paymentOptionId: payment['payment_option_id'],
      name: payment['name'],
      accountNumber: payment['account_number'],
      description: payment['description'],
    );
  }
}
