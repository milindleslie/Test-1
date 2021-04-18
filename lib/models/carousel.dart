class CarouselData {
  int id;
  String name;
  String description;
  String imageURL;

  CarouselData({this.id, this.name, this.description, this.imageURL});

  CarouselData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageURL = json['imageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageURL'] = this.imageURL;

    return data;
  }
}
