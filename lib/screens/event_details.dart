import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:test_app/custom_widgets/app_widgets.dart';
import 'package:test_app/helpers/extensions.dart';
import 'package:test_app/helpers/size_config.dart';
import 'package:test_app/models/event_details.dart';
import 'package:test_app/resources/text_styles.dart';
import 'package:test_app/state_management/providers/state_providers.dart';
import 'package:test_app/state_management/service_providers/events_service.dart';
import 'package:test_app/state_management/states/events_state.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsScreen extends StatefulWidget {
  final int eventID;

  const EventDetailsScreen({Key key, this.eventID}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> with TickerProviderStateMixin {
  final _serviceProvider = StateNotifierProvider.autoDispose<EventsService>((ref) {
    return EventsService(ref.read); // Use correct service!
  });

  AnimationController _animationController;
  Animation _colorTween;
  Animation offsetAnimation;
  Animation sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorTween = ColorTween(begin: Colors.blueGrey, end: Colors.red).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        1.0,
        curve: Curves.easeInCubic,
      ),
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });

    sizeAnimation = Tween(begin: 1.0, end: 1.3).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeInCubic,
        )));

    loadData(initialLoad: true);
  }

  Future<void> loadData({bool initialLoad}) async {
    await context.read(_serviceProvider).getEventDetails(
        initialLoad: initialLoad,
        id: widget.eventID,
        completion: (result, error) {
          if (result == false) {
            AppWidgets.showToast("Oops. Cannot load data. Please try again later");
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
    return Consumer(builder: (context, watch, child) {
      var screenState = watch(_serviceProvider.state);
      var eventDetails = watch(eventDetailsProvider);

      return Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.black38,
              automaticallyImplyLeading: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: AppWidgets.svgIcon(icon: 'assets/icons/share-arrow.svg'),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return loadData(initialLoad: false);
              },
              child: SafeArea(
                top: false,
                child: screenState.viewState == ViewState.fetching
                    ? AppFetchingLoader(screenState.viewState)
                    : Stack(
                        children: [
                          NestedScrollView(
                            floatHeaderSlivers: false,
                            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                              return [
                                SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  elevation: 15,
                                  expandedHeight: SizeConfig.safeBlockVertical * 30,
                                  backgroundColor: Colors.transparent,
                                  flexibleSpace: Stack(
                                    children: [
                                      AppWidgets.cachedNetworkImage(url: eventDetails.state.selectedEventDetail.mainImage, width: double.infinity, height: double.infinity),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: Container(
                                          padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                          height: SizeConfig.safeBlockVertical * 20,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xff02D9E7),
                                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                                          border: Border.all(color: Colors.transparent)),
                                                      child: Text(eventDetails.state.selectedEventDetail.isPartnered ? "Partnered" : "Not Partnered",
                                                          style: AppTextStyles.whiteFont700.copyWith(fontSize: 12))),
                                                  SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                                  Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.white)),
                                                      child: Text('${eventDetails.state.selectedEventDetail.sport}', style: AppTextStyles.blackFont700.copyWith(fontSize: 12))),
                                                ],
                                              ),
                                              Text(eventDetails.state.selectedEventDetail.name, style: AppTextStyles.whiteFont700.copyWith(fontSize: 20)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(children: [
                                                    AppWidgets.svgIcon(icon: 'assets/icons/ic_event_time.svg', size: 15),
                                                    SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                                                    Text('${formattedDateAndTime(eventDetails.state.selectedEventDetail.dateTime)}',
                                                        style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13)),
                                                  ]),
                                                  Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                      decoration: BoxDecoration(
                                                          color: Color(0xff02D9E7), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                                                      child: Text('£ ${eventDetails.state.selectedEventDetail.price}', style: AppTextStyles.whiteFont700.copyWith(fontSize: 17)))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ];
                            },
                            body: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildPriceAndShareInfo(eventDetails.state.selectedEventDetail),
                                  _buildTicketsInfo(eventDetails.state.selectedEventDetail),
                                  _buildTags(eventDetails.state.selectedEventDetail),
                                  _buildAboutInfo(eventDetails.state.selectedEventDetail),
                                  _buildVenueInfo(eventDetails.state.selectedEventDetail),
                                  _buildCreatorInfo(eventDetails.state.selectedEventDetail),
                                  _buildLocationInfo(eventDetails.state.selectedEventDetail),
                                  _buildContactInfo(eventDetails.state.selectedEventDetail),
                                  _buildTeamInfo(eventDetails.state.selectedEventDetail),
                                  buildSimilarEvents(eventDetails.state.eventDetails)
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: BottomButton(
                                text: "£${eventDetails.state.selectedEventDetail.price} - I’M IN!",
                                buttonColor: Color(0xff11D0A2),
                                textStyle: AppTextStyles.whiteFont600.copyWith(fontSize: 16),
                              )),
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

  Widget _buildPriceAndShareInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Total Prize: ', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 14)),
                  Text('£${eventDetails.totalPrize}', style: AppTextStyles.blackFont700.copyWith(fontSize: 14)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Color(0xff9DA6B1), borderRadius: BorderRadius.all(Radius.circular(50)), border: Border.all(color: Colors.transparent)),
                      child: Row(
                        children: [
                          AppWidgets.svgIcon(icon: 'assets/icons/ic_follow.svg', size: 18),
                          SizedBox(width: SizeConfig.safeBlockHorizontal),
                          Text('Share Event', style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 12)),
                        ],
                      )),
                  // SizedBox(width: SizeConfig.safeBlockHorizontal * 8),
                  AnimatedBuilder(
                      animation: _animationController,
                      builder: (buildContext, child) {
                        return Transform.scale(
                          scale: sizeAnimation.value,
                          child: IconButton(
                            icon: AppWidgets.svgIcon(icon: 'assets/icons/heart.svg', size: 18, color: _colorTween.value),
                            onPressed: () {
                              if (_animationController.isCompleted) {
                                _animationController.reverse();
                              } else {
                                _animationController.forward();
                              }
                            },
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 3),
          Row(children: [
            AppWidgets.svgIcon(icon: 'assets/icons/ic_ticket_black.svg', size: 16),
            SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
            Text('${eventDetails.ticketsSold}/${eventDetails.maxTickets} attending',
                style: AppTextStyles.blackFontNormal.copyWith(fontSize: 14, decoration: TextDecoration.underline, color: Color(0xff7555CF))),
          ]),
        ],
      ),
    );
  }

  Widget _buildTags(EventDetails eventDetails) {
    var tags1 = eventDetails.tags.split(',').toList();
    var tags = tags1.map((e) => e.replaceAll('[', '').replaceAll(']', '').replaceAll("\\", '').replaceAll('"', '')).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            SizedBox(height: SizeConfig.safeBlockVertical * 3),
            Wrap(
              children: List.generate(tags.length, (index) {
                return Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Color(0xffFDF7F8), borderRadius: BorderRadius.all(Radius.circular(50)), border: Border.all(color: Colors.transparent)),
                    child: Text('#${tags[index]}', style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 12, color: Color(0xffD29489))));
              }),
            ),
            SizedBox(height: SizeConfig.safeBlockVertical * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('ABOUT :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text(eventDetails.description, style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15), textAlign: TextAlign.justify),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Divider(color: Colors.black12, thickness: 1)
        ],
      ),
    );
  }

  Widget _buildVenueInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('VENUE INFORMATION :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text(eventDetails.venueInformation, style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15), textAlign: TextAlign.justify),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Divider(color: Colors.black12, thickness: 1)
        ],
      ),
    );
  }

  Widget _buildCreatorInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('EVENT CREATED BY :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Row(
            children: [
              AppWidgets.svgIcon(icon: 'assets/icons/creator.svg', size: 15),
              SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
              Flexible(child: Text(eventDetails.eventCreator, style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15), textAlign: TextAlign.justify)),
            ],
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Divider(color: Colors.black12, thickness: 1)
        ],
      ),
    );
  }

  Widget _buildLocationInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('LOCATION :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    AppWidgets.svgIcon(icon: 'assets/icons/ic_location.svg', size: 15),
                    SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                    Flexible(child: Text(eventDetails.location, style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15))),
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.safeBlockHorizontal * 5),
              FlatButton(
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () {
                    MapsLauncher.launchQuery(eventDetails.location);
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Color(0xff6658D3))),
                      child: Text('Take me there', style: AppTextStyles.whiteFont700.copyWith(fontSize: 12, color: Color(0xff6658D3)))))
            ],
          ),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Divider(color: Colors.black12, thickness: 1)
        ],
      ),
    );
  }

  Widget _buildContactInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('CONTACT :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          RichText(
              text: new TextSpan(children: [
            new TextSpan(text: "Send us an email at ", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
            new TextSpan(
                text: "contact@techalchemy.co",
                style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15, color: Color(0xff6658D3)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // openEmailApp(context);
                    _sendMail();
                  }),
            new TextSpan(text: "or call us at +1 991-681-0200", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          ])),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Divider(color: Colors.black12, thickness: 1)
        ],
      ),
    );
  }

  Widget _buildTeamInfo(EventDetails eventDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('TEAM INFORMATION :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Text('${eventDetails.teamInformation}', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
          SizedBox(height: SizeConfig.safeBlockVertical * 2),
          Divider(color: Colors.black12, thickness: 1)
        ],
      ),
    );
  }

  Widget buildSimilarEvents(List<EventDetails> eventDetails) {
    var selectedEvent = context.read(eventDetailsProvider).state.selectedEventDetail;
    var events = eventDetails.where((element) => element.sport == selectedEvent.sport && element.id != selectedEvent.id).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.safeBlockVertical * 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
          child: Text('SIMILAR EVENTS :', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 15)),
        ),
        SizedBox(height: SizeConfig.safeBlockVertical * 2),
        Container(
          height: SizeConfig.blockSizeVertical * 55,
          child: Swiper(
            itemCount: events.length,
            viewportFraction: 0.9,
            pagination: new SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder: new DotSwiperPaginationBuilder(color: Color(0xffDAD6E7), activeColor: Color(0xff475464), size: 7, activeSize: 7),
            ),
            loop: false,
            // control: new SwiperControl(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(
                  right: SizeConfig.safeBlockHorizontal * 3,
                  bottom: SizeConfig.safeBlockVertical * 5,
                ),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => EventDetailsScreen(eventID: events[index].id))),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)], borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                            height: SizeConfig.safeBlockVertical * 25,
                            padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                            decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(events[index].mainImage), fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Color(0xff02D9E7), borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.transparent)),
                                        child: Text(events[index].isPartnered ? "Partnered" : "Not Partnered", style: AppTextStyles.whiteFont700.copyWith(fontSize: 12))),
                                    SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration:
                                            BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.white)),
                                        child: Text('${events[index].sport}', style: AppTextStyles.blackFont700.copyWith(fontSize: 12))),
                                  ],
                                ),
                                Text(events[index].name, style: AppTextStyles.whiteFont700.copyWith(fontSize: 20)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      AppWidgets.svgIcon(icon: 'assets/icons/ic_event_time.svg', size: 15),
                                      SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                                      Text('${formattedDateAndTime(events[index].dateTime)}', style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13)),
                                    ]),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration:
                                            BoxDecoration(color: Color(0xff02D9E7), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                                        child: Text('£ ${events[index].price}', style: AppTextStyles.whiteFont700.copyWith(fontSize: 17)))
                                  ],
                                )
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: SizeConfig.safeBlockVertical * 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('Total Prize: ', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 14)),
                                      Text('£${events[index].totalPrize}', style: AppTextStyles.blackFont700.copyWith(fontSize: 14)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AppWidgets.svgIcon(icon: 'assets/icons/share.svg', size: 16),
                                      SizedBox(width: SizeConfig.safeBlockHorizontal * 8),
                                      AppWidgets.svgIcon(icon: 'assets/icons/heart.svg', size: 16)
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.safeBlockVertical * 2),
                              Row(children: [
                                AppWidgets.svgIcon(icon: 'assets/icons/timer.svg', size: 16),
                                SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                Text('Time Left to Book: ', style: AppTextStyles.blackFont600.copyWith(fontSize: 14, color: Color(0xff02D9E7))),
                                Text('3 hours', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13)),
                              ]),
                              SizedBox(height: SizeConfig.safeBlockVertical * 2),
                              Row(children: [
                                AppWidgets.svgIcon(icon: 'assets/icons/ic_ticket_black.svg', size: 16),
                                SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                Text('${events[index].ticketsSold}/${events[index].maxTickets} attending total', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 14)),
                              ]),
                              SizedBox(height: SizeConfig.safeBlockVertical * 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(children: [
                                      AppWidgets.svgIcon(icon: 'assets/icons/ic_location.svg', size: 16),
                                      SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                      Flexible(
                                        child: Text(
                                          '${events[index].location}',
                                          style: AppTextStyles.blackFontNormal.copyWith(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ]),
                                  ),
                                  Text('1km', style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13)),
                                ],
                              ),
                              SizedBox(height: SizeConfig.safeBlockVertical * 5),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: SizeConfig.safeBlockVertical * 15),
      ],
    );
  }

  void openEmailApp(BuildContext context) {
    try {
      AppAvailability.launchApp(Platform.isIOS ? "googlegmail" : "com.google.android.gm").then((_) {}).catchError((err) {
        AppWidgets.showToast("Gmail not found");
        print(err);
      });
    } catch (e) {
      AppWidgets.showToast("App Email not found");
    }
  }

  _sendMail() async {
    // Android and iOS

    const uri = 'mailto:contact@techalchemy.co?subject=Greetings from MLP11&body=Some static text to be placed';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      AppWidgets.showToast("Cannot open email app");
      // throw 'Could not launch $uri';;
    }
  }
}
