class Charge {
  String? id;
  int? amount;
  String? balanceTransaction;
  Map<String, dynamic>? billingDetails;
  String? currency;
  String? customer;
  String? description;
  bool? disputed;
  String? invoice;
  Map<String, dynamic>? metadata;
  String? paymentIntent;
  Map<String, dynamic>? paymentMethodDetails;
  String? receiptEmail;
  bool? refunded;
  Map<String, dynamic>? shipping;
  String? statementDescriptor;
  String? statementDescriptorSuffix;
  String? status; // Enum values can be handled separately
  String? object;
  int? amountCaptured;
  int? amountRefunded;
  String? application;
  String? applicationFee;
  int? applicationFeeAmount;
  String? calculatedStatementDescriptor;
  bool? captured;
  int? created; // timestamp
  String? failureBalanceTransaction;
  String? failureCode;
  String? failureMessage;
  Map<String, dynamic>? fraudDetails;
  bool? liveMode;
  String? onBehalfOf;
  Map<String, dynamic>? outcome;
  bool? paid;
  String? paymentMethod;
  Map<String, dynamic>? radarOptions;
  String? receiptNumber;
  String? receiptUrl;
  Map<String, dynamic>? refunds;
  String? review;
  String? sourceTransfer;
  String? transfer;
  Map<String, dynamic>? transferData;
  String? transferGroup;

  Charge({
    this.id,
    this.amount,
    this.balanceTransaction,
    this.billingDetails,
    this.currency,
    this.customer,
    this.description,
    this.disputed,
    this.invoice,
    this.metadata,
    this.paymentIntent,
    this.paymentMethodDetails,
    this.receiptEmail,
    this.refunded,
    this.shipping,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.object,
    this.amountCaptured,
    this.amountRefunded,
    this.application,
    this.applicationFee,
    this.applicationFeeAmount,
    this.calculatedStatementDescriptor,
    this.captured,
    this.created,
    this.failureBalanceTransaction,
    this.failureCode,
    this.failureMessage,
    this.fraudDetails,
    this.liveMode,
    this.onBehalfOf,
    this.outcome,
    this.paid,
    this.paymentMethod,
    this.radarOptions,
    this.receiptNumber,
    this.receiptUrl,
    this.refunds,
    this.review,
    this.sourceTransfer,
    this.transfer,
    this.transferData,
    this.transferGroup,
  });

  // fromJson
  Charge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    balanceTransaction = json['balance_transaction'];
    billingDetails = json['billing_details'];
    currency = json['currency'];
    customer = json['customer'];
    description = json['description'];
    disputed = json['disputed'];
    invoice = json['invoice'];
    metadata = json['metadata'];
    paymentIntent = json['payment_intent'];
    paymentMethodDetails = json['payment_method_details'];
    receiptEmail = json['receipt_email'];
    refunded = json['refunded'];
    shipping = json['shipping'];
    statementDescriptor = json['statement_descriptor'];
    statementDescriptorSuffix = json['statement_descriptor_suffix'];
    status = json['status'];
    object = json['object'];
    amountCaptured = json['amount_captured'];
    amountRefunded = json['amount_refunded'];
    application = json['application'];
    applicationFee = json['application_fee'];
    applicationFeeAmount = json['application_fee_amount'];
    calculatedStatementDescriptor = json['calculated_statement_descriptor'];
    captured = json['captured'];
    created = json['created'];
    failureBalanceTransaction = json['failure_balance_transaction'];
    failureCode = json['failure_code'];
    failureMessage = json['failure_message'];
    fraudDetails = json['fraud_details'];
    liveMode = json['live_mode'];
    onBehalfOf = json['on_behalf_of'];
    outcome = json['outcome'];
    paid = json['paid'];
    paymentMethod = json['payment_method'];
    radarOptions = json['radar_options'];
    receiptNumber = json['receipt_number'];
    receiptUrl = json['receipt_url'];
    refunds = json['refunds'];
    review = json['review'];
    sourceTransfer = json['source_transfer'];
    transfer = json['transfer'];
    transferData = json['transfer_data'];
    transferGroup = json['transfer_group'];
  }

  // toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['balance_transaction'] = balanceTransaction;
    data['billing_details'] = billingDetails;
    data['currency'] = currency;
    data['customer'] = customer;
    data['description'] = description;
    data['disputed'] = disputed;
    data['invoice'] = invoice;
    data['metadata'] = metadata;
    data['payment_intent'] = paymentIntent;
    data['payment_method_details'] = paymentMethodDetails;
    data['receipt_email'] = receiptEmail;
    data['refunded'] = refunded;
    data['shipping'] = shipping;
    data['statement_descriptor'] = statementDescriptor;
    data['statement_descriptor_suffix'] = statementDescriptorSuffix;
    data['status'] = status;
    data['object'] = object;
    data['amount_captured'] = amountCaptured;
    data['amount_refunded'] = amountRefunded;
    data['application'] = application;
    data['application_fee'] = applicationFee;
    data['application_fee_amount'] = applicationFeeAmount;
    data['calculated_statement_descriptor'] = calculatedStatementDescriptor;
    data['captured'] = captured;
    data['created'] = created;
    data['failure_balance_transaction'] = failureBalanceTransaction;
    data['failure_code'] = failureCode;
    data['failure_message'] = failureMessage;
    data['fraud_details'] = fraudDetails;
    data['live_mode'] = liveMode;
    data['on_behalf_of'] = onBehalfOf;
    data['outcome'] = outcome;
    data['paid'] = paid;
    data['payment_method'] = paymentMethod;
    data['radar_options'] = radarOptions;
    data['receipt_number'] = receiptNumber;
    data['receipt_url'] = receiptUrl;
    data['refunds'] = refunds;
    data['review'] = review;
    data['source_transfer'] = sourceTransfer;
    data['transfer'] = transfer;
    data['transfer_data'] = transferData;
    data['transfer_group'] = transferGroup;
    return data;
  }
}
