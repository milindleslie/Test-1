// String timeUntil(String date) {
//   var inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
//   var inputDate = DateTime.parse(date).toLocal();
//
//   return timeago.format(inputDate, locale: "", allowFromNow: true);
// }

import 'package:intl/intl.dart';

enum ShortDays { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

enum ShortMonths { Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec }

// enum LongMonths { January, February, March, April, May, June, July, August, September, October, November, December }

// String getFormattedShortDateFromTimeStamp(int timeStamp) {
//   DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
//   return "${ShortDays.values[date.weekday - 1].toString().split('.').last} ${date.day.toString().padLeft(2, '0')} ${ShortMonths.values[date.month - 1].toString().split('.').last}";
// }

// String getFormattedShortDateFromDate(DateTime date) {
//   return "${ShortDays.values[date.weekday - 1].toString().split('.').last} ${date.day.toString().padLeft(2, '0')} ${ShortMonths.values[date.month - 1].toString().split('.').last}";
// }

String formattedDateAndTime(String date) {
  var inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  var inputDate = inputFormat.parse(date);

  return "${ShortDays.values[inputDate.weekday - 1].toString().split('.').toList().last}, ${inputDate.day} ${ShortMonths.values[inputDate.month - 1].toString().split('.').last} "
      "${inputDate.year} ${inputDate.hour}"
      ":${inputDate.minute}";
}

String getFormattedShortDateFromTimeStamp(int timeStamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return "${date.day} ${ShortMonths.values[date.month - 1].toString().split('.').last} ${date.year}";
}

String getFormattedShortDateFromDate(DateTime date) {
  return "${date.day} ${ShortMonths.values[date.month - 1].toString().split('.').last} ${date.year}";
}
