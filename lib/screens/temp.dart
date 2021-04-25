import 'package:flutter/material.dart';

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Container();

    // Stack(
    //   children: [
    //     Container(
    //       height: SizeConfig.safeBlockVertical * 36,
    //       child: Column(
    //         children: [
    //           SizedBox(height: SizeConfig.safeBlockVertical),
    //           Padding(
    //             padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text("Recommended Events", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13)),
    //                 FlatButton(
    //                     onPressed: () {},
    //                     child: Text("View all", style: AppTextStyles.blackFontNormal.copyWith(fontSize: 13, color: Colors.orange)),
    //                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //                     padding: EdgeInsets.zero)
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: SizeConfig.safeBlockVertical * 2),
    //           buildRecommendedEvents(eventsFeed.state.allEvents)
    //         ],
    //       ),
    //     ),
    //     SizedBox.expand(
    //       child: DraggableScrollableSheet(
    //         builder: (BuildContext context, ScrollController scrollController) {
    //           return buildAllEventsList(eventsFeed.state.allEvents, scrollController);
    //         },
    //       ),
    //     )
    //   ],
    // )
  }
}
