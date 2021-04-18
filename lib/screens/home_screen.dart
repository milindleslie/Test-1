import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:test_app/custom_widgets/app_widgets.dart';
import 'package:test_app/custom_widgets/product_widget.dart';
import 'package:test_app/helpers/size_config.dart';
import 'package:test_app/models/banner.dart';
import 'package:test_app/models/carousel.dart';
import 'package:test_app/models/product.dart';
import 'package:test_app/resources/colors.dart';
import 'package:test_app/resources/text_styles.dart';
import 'package:test_app/state_management/providers/state_providers.dart';
import 'package:test_app/state_management/service_providers/home_feed_service.dart';
import 'package:test_app/state_management/states/home_feed_state.dart';

class HomeScreen extends StatefulWidget {
  final int groupID;
  final bool shouldShowBackButton;

  const HomeScreen({Key key, this.groupID, this.shouldShowBackButton = true}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _serviceProvider = StateNotifierProvider.autoDispose<HomeFeedService>((ref) {
    return HomeFeedService(ref.read); // Use correct service!
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      loadData(initialLoad: true);
    });
  }

  Future<void> loadData({bool initialLoad}) async {
    await context.read(_serviceProvider).getHomeFeed(
        initialLoad: initialLoad,
        completion: (result, error) {
          if (result == false) {
            // AppWidgets.showAlertDialogue(context: context, title: 'Home Feed', message: error, defaultButtonTitle: 'OK');
          }
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer(builder: (context, watch, child) {
      var screenState = watch(_serviceProvider.state);
      var homeFeed = watch(homeFeedStateProvider);

      return Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.lightBackground,
            extendBodyBehindAppBar: true,
            body: RefreshIndicator(
              onRefresh: () {
                return loadData(initialLoad: false);
              },
              child: SafeArea(
                top: false,
                child: screenState.viewState == ViewState.fetching
                    ? AppFetchingLoader(screenState.viewState)
                    : CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: SizeConfig.safeBlockVertical * 30,
                            flexibleSpace: buildCarousel(homeFeed.state.carouselImages),
                            backgroundColor: Colors.transparent,
                            stretch: true,
                          ),
                          SliverAppBar(
                            toolbarHeight: 45,
                            pinned: true,
                            backgroundColor: Colors.lightBlueAccent,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Discounts For You", style: AppTextStyles.blackFont14),
                                FlatButton(onPressed: () {}, child: Text("View all >", style: AppTextStyles.whiteFont12), color: Colors.blue)
                              ],
                            ),
                            automaticallyImplyLeading: false,
                            centerTitle: false,
                          ),
                          new SliverList(
                              delegate: SliverChildListDelegate([
                            Container(
                              color: Colors.lightBlueAccent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 3, vertical: SizeConfig.safeBlockVertical * 2),
                                child: buildDiscountedProductsGrid(homeFeed.state.products),
                              ),
                            ),
                            buildBanner(homeFeed.state.banner),
                          ])),
                        ],
                      ),
              ),
            ),
          ),
          AppBusyLoader(screenState.viewState)
        ],
      );
    });
  }

  Widget buildCarousel(List<CarouselData> carouselImages) {
    return Swiper(
      itemCount: carouselImages.length,
      autoplay: true,
      loop: true,
      pagination: new SwiperPagination(),
      // control: new SwiperControl(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.amber),
            child: AppWidgets.cachedNetworkImage(url: carouselImages[index].imageURL, height: double.infinity, width: double.infinity));
      },
    );
  }

  Widget buildDiscountedProductsGrid(List<Product> products) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.all(Radius.circular(5.0))),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 3, vertical: SizeConfig.safeBlockVertical * 2),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(product: products[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildBanner(BannerData banner) {
    return AppWidgets.cachedNetworkImage(url: banner.imageURL, height: SizeConfig.safeBlockVertical * 25, width: double.infinity);
  }
}
