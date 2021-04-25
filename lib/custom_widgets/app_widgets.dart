import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:test_app/resources/colors.dart';
import 'package:test_app/state_management/states/events_state.dart';

class AppWidgets {
  static Widget svgIcon({@required String icon, double size = 24, Color color}) {
    return SvgPicture.asset(icon, height: size, width: size, color: color, fit: BoxFit.contain);
  }

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

  static showToast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 12.0,
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
            child:
                SizedBox(width: deviceInfo.size.width * 0.2, child: LoadingIndicator(indicatorType: Indicator.ballScaleRippleMultiple, color: AppColors.appBlueColor), height: 20),
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
            child:
                SizedBox(width: deviceInfo.size.width * 0.2, child: LoadingIndicator(indicatorType: Indicator.ballScaleRippleMultiple, color: AppColors.appBlueColor), height: 20),
          )
        : Container();
  }
}

class BottomButton extends StatelessWidget {
  String text;
  Function onPressed;
  TextStyle textStyle;
  Color buttonColor;
  double topMargin;
  double bottomMargin;
  bool disabled;

  BottomButton({
    this.text = "",
    this.onPressed,
    this.disabled = false,
    this.textStyle,
    this.buttonColor,
    this.topMargin,
    this.bottomMargin,
  });

  @override
  Widget build(BuildContext context) {
    var deviceInfo = MediaQuery.of(context);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12)]),
      child: FlatButton(
        onPressed: disabled ? null : onPressed,
        child: Container(
          margin: EdgeInsets.only(top: topMargin ?? 15.0, bottom: bottomMargin ?? 15.0),
          alignment: Alignment.center,
          child: Text(text, style: textStyle),
          width: deviceInfo.size.width - (deviceInfo.size.width / 9),
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), color: disabled ? Colors.grey : buttonColor ?? Color(0xff199fdd)),
        ),
      ),
    );
  }
}
