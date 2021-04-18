import 'package:test_app/models/banner.dart';
import 'package:test_app/models/carousel.dart';
import 'package:test_app/models/product.dart';

class HomeFeedResponse {
  int code;
  String status;
  String message;
  List<CarouselData> carouselData;
  List<Product> products;
  BannerData banner;

  HomeFeedResponse({this.code, this.status, this.message, this.products});

  static HomeFeedResponse parse(dynamic json) {
    return HomeFeedResponse.fromJson(json);
  }

  HomeFeedResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['carouselData'] != null) {
      carouselData = new List<CarouselData>();
      json['carouselData'].forEach((v) {
        carouselData.add(new CarouselData.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
    banner = json['banner'] != null ? new BannerData.fromJson(json['banner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.carouselData != null) {
      data['carouselData'] = this.carouselData.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.toJson();
    }

    return data;
  }
}