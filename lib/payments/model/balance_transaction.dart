class BalanceTransaction {
  final String? id;
  final String? object;
  final int? amount;
  final int? availableOn;
  final int? created;
  final String? currency;
  final String? description;
  final dynamic exchangeRate; // already nullable because it's dynamic
  final int? fee;
  final List<dynamic>? feeDetails;
  final int? net;
  final String? reportingCategory;
  final String? source;
  final String? status;
  final String? type;

  BalanceTransaction(
      {this.id,
      this.object,
      this.amount,
      this.availableOn,
      this.created,
      this.currency,
      this.description,
      this.exchangeRate,
      this.fee,
      this.feeDetails,
      this.net,
      this.reportingCategory,
      this.source,
      this.status,
      this.type});

  factory BalanceTransaction.fromJson(Map<String, dynamic> json) {
    return BalanceTransaction(
        id: json['id'],
        object: json['object'],
        amount: json['amount'],
        availableOn: json['available_on'],
        created: json['created'],
        currency: json['currency'],
        description: json['description'],
        exchangeRate: json['exchange_rate'],
        fee: json['fee'],
        feeDetails: json['fee_details'],
        net: json['net'],
        reportingCategory: json['reporting_category'],
        source: json['source'],
        status: json['status'],
        type: json['type']);
  }
}
