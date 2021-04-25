class PurchaseRequest {
  Purchase purchase;

  PurchaseRequest({this.purchase});

  PurchaseRequest.fromJson(Map<String, dynamic> json) {
    purchase = json['purchase'] != null ? new Purchase.fromJson(json['purchase']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchase != null) {
      data['purchase'] = this.purchase.toJson();
    }
    return data;
  }
}

class Purchase {
  String dateTime;
  int purchaseAmount;
  String paymentMethodType;
  int eventId;

  Purchase({this.dateTime, this.purchaseAmount, this.paymentMethodType, this.eventId});

  Purchase.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    purchaseAmount = json['purchaseAmount'];
    paymentMethodType = json['paymentMethodType'];
    eventId = json['eventId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['purchaseAmount'] = this.purchaseAmount;
    data['paymentMethodType'] = this.paymentMethodType;
    data['eventId'] = this.eventId;
    return data;
  }
}

class PurchaseResponse {
  Purchased purchase;

  PurchaseResponse({this.purchase});

  PurchaseResponse.fromJson(Map<String, dynamic> json) {
    purchase = json['purchase'] != null ? new Purchased.fromJson(json['purchase']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.purchase != null) {
      data['purchase'] = this.purchase.toJson();
    }
    return data;
  }
}

class Purchased {
  String dateTime;
  int purchaseAmount;
  String paymentMethodType;
  int eventId;
  int id;

  Purchased({this.dateTime, this.purchaseAmount, this.paymentMethodType, this.eventId, this.id});

  Purchased.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    purchaseAmount = json['purchaseAmount'];
    paymentMethodType = json['paymentMethodType'];
    eventId = json['eventId'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateTime'] = this.dateTime;
    data['purchaseAmount'] = this.purchaseAmount;
    data['paymentMethodType'] = this.paymentMethodType;
    data['eventId'] = this.eventId;
    data['id'] = this.id;
    return data;
  }
}
