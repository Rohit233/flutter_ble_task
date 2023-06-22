import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {


  static String getFormatedDate(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }

  static String getFormatedTime(BuildContext context,DateTime dateTime) {
      return TimeOfDay.fromDateTime(dateTime).format(context);
  }

}