import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test_app/state_management/states/home_feed_state.dart';

class AppWidgets {
  static Widget cachedNetworkImage({String url, double width, double height, BorderRadius borderRadius, Widget placeHolderImage, bool shadow = false}) {
    return Material(
      // elevation: 2,
      color: Colors.transparent,
      elevation: shadow ? 2 : 0,
      shadowColor: shadow ? Colors.black87 : Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.hardEdge,
      child: url != null
          ? CachedNetworkImage(
              // filterQuality: FilterQuality.none,
              fadeInCurve: Curves.easeIn,
              fadeOutCurve: Curves.easeOut,
              fadeInDuration: Duration(milliseconds: 100),
              fadeOutDuration: Duration(milliseconds: 100),
              imageUrl: url,
              width: width ?? null,
              height: height ?? null,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 0.2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))),
              errorWidget: (context, url, error) => Image.asset('assets/images/no_image.jpg', fit: BoxFit.cover, width: width, height: height),
            )
          : placeHolderImage ?? Icon(Icons.image, size: height ?? 50.0, color: Colors.blue),
    );
  }
}

class AppFetchingLoader extends StatelessWidget {
  final ViewState viewState;

  AppFetchingLoader(this.viewState);

  Widget build(BuildContext context) {
    var deviceInfo = MediaQuery.of(context);

    return viewState == ViewState.fetching
        ? Container(
            color: Colors.black12,
            alignment: Alignment.center,
            child: SizedBox(width: deviceInfo.size.width * 0.2, child: LoadingIndicator(indicatorType: Indicator.ballRotateChase, color: Colors.orange)),
          )
        : Container();
  }
}

class AppBusyLoader extends StatelessWidget {
  final ViewState viewState;

  AppBusyLoader(this.viewState);

  Widget build(BuildContext context) {
    var deviceInfo = MediaQuery.of(context);

    // if (onlyBusyMode) return Container();
    return viewState == ViewState.busy
        ? Container(
            color: Colors.black12,
            alignment: Alignment.center,
            child: SizedBox(width: deviceInfo.size.width * 0.2, child: LoadingIndicator(indicatorType: Indicator.ballRotateChase, color: Colors.orange)),
          )
        : Container();
  }
}
