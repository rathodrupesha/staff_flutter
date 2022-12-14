import 'package:hamrostay/Utils/app_date_format.dart';
import 'package:hamrostay/Utils/date_utils.dart';
import 'package:intl/intl.dart';

class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat(AppDateFormat.serverDateTimeFormat1,).parse(dateString);
    notificationDate= notificationDate.add(DateTime.now().timeZoneOffset);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 7) {
      return DateUtilss.dateToString(notificationDate,format: AppDateFormat.fullDateTimeFormat);
    } else if (difference.inDays >= 1) {
      return DateUtilss.dateToString(notificationDate,format: AppDateFormat.fullDateTimeFormat1);
    } /*else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    }*/ else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

} 