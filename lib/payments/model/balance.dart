class Balance {
  final String? object;
  final bool? liveMode;
  final List<BalanceItem>? available;
  final List<BalanceItem>? pending;
  final List<ConnectReserved>? connectReserved;

  Balance(
      {this.object,
      this.liveMode,
      this.available,
      this.pending,
      this.connectReserved});

  factory Balance.fromJson(Map<String, dynamic> json) {
    var availList = json['available'] as List?;
    List<BalanceItem> availableList =
        availList?.map((i) => BalanceItem.fromJson(i)).toList() ?? [];

    var pendList = json['pending'] as List?;
    List<BalanceItem> pendingList =
        pendList?.map((i) => BalanceItem.fromJson(i)).toList() ?? [];

    var connList = json['connect_reserved'] as List?;
    List<ConnectReserved> connListItems =
        connList?.map((i) => ConnectReserved.fromJson(i)).toList() ?? [];

    return Balance(
      object: json['object'],
      liveMode: json['livemode'],
      available: availableList,
      pending: pendingList,
      connectReserved: connListItems,
    );
  }
}

class BalanceItem {
  final int? amount;
  final String? currency;
  final SourceTypes? sourceTypes;

  BalanceItem({this.amount, this.currency, this.sourceTypes});

  factory BalanceItem.fromJson(Map<String, dynamic> json) {
    return BalanceItem(
      amount: json['amount'],
      currency: json['currency'],
      sourceTypes: json['source_types'] != null
          ? SourceTypes.fromJson(json['source_types'])
          : null,
    );
  }
}

class ConnectReserved {
  final int? amount;
  final String? currency;

  ConnectReserved({this.amount, this.currency});

  factory ConnectReserved.fromJson(Map<String, dynamic> json) {
    return ConnectReserved(
      amount: json['amount'],
      currency: json['currency'],
    );
  }
}

class SourceTypes {
  final int? card;

  SourceTypes({this.card});

  factory SourceTypes.fromJson(Map<String, dynamic> json) {
    return SourceTypes(
      card: json['card'],
    );
  }
}
