class Product {
  int id;
  String name;
  String description;
  int off;
  String imageURL;

  Product({this.id, this.name, this.description, this.off, this.imageURL});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    off = json['off'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['off'] = this.off;
    data['imageURL'] = this.imageURL;

    return data;
  }
}
