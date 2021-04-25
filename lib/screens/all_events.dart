import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:test_app/custom_widgets/app_widgets.dart';
import 'package:test_app/helpers/extensions.dart';
import 'package:test_app/helpers/size_config.dart';
import 'package:test_app/models/all_events.dart';
import 'package:test_app/resources/colors.dart';
import 'package:test_app/resources/text_styles.dart';
import 'package:test_app/screens/event_details.dart';
import 'package:test_app/state_management/providers/state_providers.dart';
import 'package:test_app/state_management/service_providers/events_service.dart';
import 'package:test_app/state_management/states/events_state.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({Key key}) : super(key: key);

  @override
  _AllEventsScreenState createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> with TickerProviderStateMixin {
  final _serviceProvider = StateNotifierProvider.autoDispose<EventsService>((ref) {
    return EventsService(ref.read); // Use correct service!
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Future.delayed(Duration(milliseconds: 200), () {
    loadData(initialLoad: true);
    // });
  }

  Future<void> loadData({bool initialLoad}) async {
    await context.read(_serviceProvider).getAllEvents(
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
      var eventsFeed = watch(allEventsStateProvider);

      return Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.appBlueColor,
              title: Text('Welcome', style: AppTextStyles.whiteFont600),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: AppWidgets.svgIcon(icon: 'assets/icons/Group 70.svg'),
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
                    : NestedScrollView(
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              pinned: true,
                              elevation: 15,
                              collapsedHeight: SizeConfig.safeBlockVertical * 11,
                              expandedHeight: SizeConfig.safeBlockVertical * 11,
                              backgroundColor: Colors.transparent,
                              flexibleSpace: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.appBlueColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration:
                                      BoxDecoration(color: Colors.white10, border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(20))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      AppWidgets.svgIcon(icon: 'assets/icons/ic.svg', size: 18),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                                      Flexible(
                                          child: TextField(
                                              style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13, color: Colors.white),
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  hintText: "Search by event, code, location",
                                                  hintStyle: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13, color: Colors.white70),
                                                  border: InputBorder.none))),
                                      SizedBox(width: SizeConfig.blockSizeHorizontal),
                                      AppWidgets.svgIcon(icon: 'assets/icons/ic_filter.svg', size: 18)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ];
                        },
                        body: Stack(
                          children: [
                            Container(
                              // height: SizeConfig.safeBlockVertical * 36,
                              child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.safeBlockVertical),
                                  Padding(
                                    padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Recommended Events", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13)),
                                        FlatButton(
                                            onPressed: () {},
                                            child: Text("View all", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13, color: Colors.orange)),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            padding: EdgeInsets.zero)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: SizeConfig.safeBlockVertical * 2),
                                  buildRecommendedEvents(eventsFeed.state.allEvents),
                                  SizedBox(height: SizeConfig.safeBlockVertical * 2),
                                ],
                              ),
                            ),
                            SizedBox.expand(
                              child: DraggableScrollableSheet(
                                initialChildSize: 0.5,
                                minChildSize: 0.5,
                                builder: (BuildContext context, ScrollController scrollController) {
                                  return buildAllEventsList(eventsFeed.state.allEvents, scrollController);
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                // CustomScrollView(
                //         slivers: <Widget>[
                //           SliverAppBar(
                //             pinned: true,
                //             elevation: 15,
                //             collapsedHeight: SizeConfig.safeBlockVertical * 12,
                //             expandedHeight: SizeConfig.safeBlockVertical * 12,
                //             backgroundColor: Colors.transparent,
                //             flexibleSpace: Container(
                //               decoration:
                //                   BoxDecoration(color: AppColors.appBlueColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
                //               child: Container(
                //                 margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                //                 padding: EdgeInsets.symmetric(horizontal: 15),
                //                 decoration:
                //                     BoxDecoration(color: Colors.white10, border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(20))),
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //                   children: [
                //                     AppWidgets.svgIcon(icon: 'assets/icons/ic.svg', size: 18),
                //                     SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                //                     Flexible(
                //                         child: TextField(
                //                             style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13, color: Colors.white),
                //                             textAlign: TextAlign.center,
                //                             decoration: InputDecoration(
                //                                 hintText: "Search by event, code, location",
                //                                 hintStyle: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13, color: Colors.white70),
                //                                 border: InputBorder.none))),
                //                     SizedBox(width: SizeConfig.blockSizeHorizontal),
                //                     AppWidgets.svgIcon(icon: 'assets/icons/ic_filter.svg', size: 18)
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           ),
                //           SliverAppBar(
                //             backgroundColor: AppColors.background,
                //             expandedHeight: SizeConfig.safeBlockVertical * 36,
                //             flexibleSpace: Column(
                //               children: [
                //                 SizedBox(height: SizeConfig.safeBlockVertical),
                //                 Padding(
                //                   padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2),
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                     children: [
                //                       Text("Recommended Events", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13)),
                //                       FlatButton(
                //                           onPressed: () {},
                //                           child: Text("View all", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13, color: Colors.orange)),
                //                           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //                           padding: EdgeInsets.zero)
                //                     ],
                //                   ),
                //                 ),
                //                 SizedBox(height: SizeConfig.safeBlockVertical * 2),
                //                 buildRecommendedEvents(eventsFeed.state.allEvents)
                //               ],
                //             ),
                //           ),
                //           new SliverList(
                //               delegate: SliverChildListDelegate([
                //             // buildAllEventsList(eventsFeed.state.allEvents),
                //           ])),
                //         ],
                //       ),
              ),
            ),
          ),
          AppBusyLoader(screenState.viewState)
        ],
      );
    });
  }

  Widget buildRecommendedEvents(List<AllEvents> events) {
    return Container(
      height: SizeConfig.blockSizeVertical * 26,
      child: Swiper(
        autoplay: true,
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
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 5,
                vertical: SizeConfig.safeBlockVertical * 2,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey, image: DecorationImage(image: NetworkImage(events[index].mainImage), fit: BoxFit.cover), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(children: [
                    AppWidgets.svgIcon(icon: 'assets/icons/ic_event_time.svg', size: 15),
                    SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                    Text('${formattedDateAndTime(events[index].dateTime)}', style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13)),
                  ]),
                  Text(events[index].name, style: AppTextStyles.whiteFont700.copyWith(fontSize: 17)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.white)),
                          child: Row(
                            children: [
                              AppWidgets.svgIcon(icon: 'assets/icons/ic_ticket.svg', size: 13),
                              SizedBox(width: SizeConfig.safeBlockHorizontal),
                              Text('${events[index].ticketsSold}/${events[index].maxTickets}', style: AppTextStyles.whiteFont700.copyWith(fontSize: 12)),
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.white)),
                          child: Text('+ ${events[index].friendsAttending} friends', style: AppTextStyles.whiteFont700.copyWith(fontSize: 12))),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Color(0xff02D9E7), borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.white)),
                          child: Text('£${events[index].price}', style: AppTextStyles.whiteFont700.copyWith(fontSize: 12))),
                    ],
                  )
                ],
              ));
        },
      ),
    );
  }

  Widget buildAllEventsList(List<AllEvents> events, ScrollController scrollController) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(),
      child: ListView.separated(
          controller: scrollController,
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 2, horizontal: SizeConfig.safeBlockHorizontal * 5),
          itemBuilder: (context, index) {
            return index == 0
                ? Text("All Events", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13))
                : GestureDetector(
                    onTap: () => Navigator.of(context).push(CupertinoPageRoute(builder: (context) => EventDetailsScreen(eventID: events[index - 1].id))),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)], borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          Container(
                              height: SizeConfig.safeBlockVertical * 25,
                              padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(events[index - 1].mainImage), fit: BoxFit.cover),
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
                                          child: Text(events[index - 1].isPartnered ? "Partnered" : "Not Partnered", style: AppTextStyles.whiteFont700.copyWith(fontSize: 12))),
                                      SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration:
                                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: Colors.white)),
                                          child: Text('${events[index - 1].sport}', style: AppTextStyles.blackFont700.copyWith(fontSize: 12))),
                                    ],
                                  ),
                                  Text(events[index - 1].name, style: AppTextStyles.whiteFont700.copyWith(fontSize: 20)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        AppWidgets.svgIcon(icon: 'assets/icons/ic_event_time.svg', size: 15),
                                        SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
                                        Text('${formattedDateAndTime(events[index - 1].dateTime)}', style: AppTextStyles.whiteFontNormal.copyWith(fontSize: 13)),
                                      ]),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                              color: Color(0xff02D9E7), borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                                          child: Text('£${events[index - 1].price}', style: AppTextStyles.whiteFont700.copyWith(fontSize: 17)))
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
                                        Text('£${events[index - 1].totalPrize}', style: AppTextStyles.blackFont700.copyWith(fontSize: 14)),
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
                                  Text('${events[index - 1].ticketsSold}/${events[index - 1].maxTickets} attending total',
                                      style: AppTextStyles.blackFontNormal.copyWith(fontSize: 14)),
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
                                            '${events[index - 1].location}',
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
                  );
          },
          separatorBuilder: (context, index) => Container(height: SizeConfig.safeBlockVertical * 2),
          itemCount: events.length + 1),
    );
  }
}
