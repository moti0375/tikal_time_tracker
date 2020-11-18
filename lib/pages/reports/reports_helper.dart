import 'package:tikal_time_tracker/pages/reports/generate_report_page.dart';
import 'package:tikal_time_tracker/resources/strings.dart';

const THIS_MONTH = 3;
const PREVIOUS_MONTH = 7;
const THIS_WEEK = 2;
const TODAY = 1;
const YESTERDAY = 8;

List<Period> availablePeriods = [
  Period(name: Strings.item_this_month, value: THIS_MONTH),
  Period(name: Strings.item_previous_month, value: PREVIOUS_MONTH),
  Period(name: Strings.item_this_week, value: THIS_WEEK),
  Period(name: Strings.item_today, value: TODAY),
  Period(name: Strings.item_yesterday, value: YESTERDAY),
];