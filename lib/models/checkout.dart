class CheckoutResponse {
  List<Checkout> checkout;

  CheckoutResponse({this.checkout});

  CheckoutResponse.fromJson(Map<String, dynamic> json) {
    if (json['checkout'] != null) {
      checkout = new List<Checkout>();
      json['checkout'].forEach((v) {
        checkout.add(new Checkout.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.checkout != null) {
      data['checkout'] = this.checkout.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Checkout {
  String name;
  String dateTime;
  double price;
  bool isPrivate;
  String location;
  String gameLength;
  String paymentMethodUnsupported;
  String mainImage;
  int id;

  Checkout({this.name, this.dateTime, this.price, this.isPrivate, this.location, this.gameLength, this.paymentMethodUnsupported, this.mainImage, this.id});

  Checkout.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dateTime = json['dateTime'];
    price = json['price'];
    isPrivate = json['isPrivate'];
    location = json['location'];
    gameLength = json['gameLength'];
    paymentMethodUnsupported = json['paymentMethodUnsupported'];
    mainImage = json['mainImage'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dateTime'] = this.dateTime;
    data['price'] = this.price;
    data['isPrivate'] = this.isPrivate;
    data['location'] = this.location;
    data['gameLength'] = this.gameLength;
    data['paymentMethodUnsupported'] = this.paymentMethodUnsupported;
    data['mainImage'] = this.mainImage;
    data['id'] = this.id;
    return data;
  }
}
