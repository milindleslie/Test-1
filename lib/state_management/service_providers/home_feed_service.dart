import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/models/banner.dart';
import 'package:test_app/models/carousel.dart';
import 'package:test_app/models/product.dart';
import 'package:test_app/state_management/providers/state_providers.dart';
import 'package:test_app/state_management/states/home_feed_state.dart';

class HomeFeedService extends StateNotifier<ScreenState> {
  final Reader read;

  HomeFeedService(this.read) : super(ScreenState(viewState: ViewState.fetching));

  Future getHomeFeed({bool initialLoad, Function(bool result, String error) completion}) async {
    /// Setting state as busy
    state = state.copyWith(viewState: initialLoad ? ViewState.fetching : ViewState.busy);

    try {
      /// Make network call here
      // Response response = await NetworkAdapter.shared.post(endPoint: EndPoint.appData);
      // HomeFeedResponse parsedResponse = HomeFeedResponse.fromJson(response.data);

      /// Calling after a delay to mock api call
      Future.delayed(Duration(seconds: 1), () {
        /// Shuffling data
        sampleCarousalImages.shuffle();
        sampleProducts.shuffle();
        sampleBannerData.shuffle();

        /// Updating state
        var provider = read(homeFeedStateProvider);
        provider.state = provider.state.copyWith(products: sampleProducts, carouselImages: sampleCarousalImages, banner: sampleBannerData.first);

        completion(true, 'success');
        state = state.copyWith(viewState: ViewState.idle);
      });
    } catch (error) {
      completion(false, error.toString());
      state = state.copyWith(viewState: ViewState.error);
    }
  }

  /// MOCK DATA FOR TESTING :-
  List<CarouselData> sampleCarousalImages = [
    CarouselData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y3w8oaah'),
    CarouselData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y4vaulog'),
    CarouselData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y3j7rq6g'),
    CarouselData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y28jpmyr'),
    CarouselData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y2w7fbdo'),
    CarouselData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/yy2f6lha'),
  ];

  List<Product> sampleProducts = [
    Product(id: 1, name: 'Product 1', description: '', imageURL: 'https://tinyurl.com/y4f5e96j', off: 50),
    Product(id: 1, name: 'Product 2', description: '', imageURL: 'https://tinyurl.com/y2szwrys', off: 70),
    Product(id: 1, name: 'Product 3', description: '', imageURL: 'https://tinyurl.com/y4bfj5b7', off: 10),
    Product(id: 1, name: 'Product 4', description: '', imageURL: 'https://tinyurl.com/y44marw5', off: 80),
    Product(id: 1, name: 'Product 5', description: '', imageURL: 'https://tinyurl.com/y4urobx8', off: 75),
    Product(id: 1, name: 'Product 6', description: '', imageURL: 'https://tinyurl.com/y2yhf95n', off: 30),
    Product(id: 1, name: 'Product 7', description: '', imageURL: 'https://tinyurl.com/y5n467o3', off: 40),
    Product(id: 1, name: 'Product 8', description: '', imageURL: 'https://tinyurl.com/yxupqdll', off: 60),
  ];

  List<BannerData> sampleBannerData = [
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y379jw6s'),
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y3pjtea4'),
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y2gersqn'),
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y3c6ksu5'),
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y4k2klen'),
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y3pccdrc'),
    BannerData(id: 1, name: '', description: '', imageURL: 'https://tinyurl.com/y26fn9rm'),
  ];
}
