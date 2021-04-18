import 'package:test_app/models/banner.dart';
import 'package:test_app/models/carousel.dart';
import 'package:test_app/models/product.dart';

enum ViewState { idle, fetching, busy, error }

class HomeFeedState {
  List<CarouselData> carouselImages;
  List<Product> products;
  BannerData banner;

  HomeFeedState({
    this.carouselImages,
    this.products,
    this.banner,
  });

  HomeFeedState copyWith({
    List<CarouselData> carouselImages,
    List<Product> products,
    BannerData banner,
  }) {
    return new HomeFeedState(
      carouselImages: carouselImages ?? this.carouselImages,
      products: products ?? this.products,
      banner: banner ?? this.banner,
    );
  }
}

class ScreenState {
  ViewState viewState;
  ScreenState({this.viewState});

  ScreenState copyWith({
    ViewState viewState,
  }) {
    return new ScreenState(
      viewState: viewState ?? this.viewState,
    );
  }
}
