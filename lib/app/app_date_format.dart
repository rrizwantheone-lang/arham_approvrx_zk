import 'package:arham_b2c/app/app_colors.dart';
import 'package:arham_b2c/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDatePicker {
  static String last7DaysDate() {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(Duration(days: 7));
    return DateFormat('dd-MM-yyyy').format(sevenDaysAgo);
  }

  static String last1MonthDate() {
    DateTime now = DateTime.now();
    DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);
    return DateFormat('dd-MM-yyyy').format(oneMonthAgo);
  }

  static String lastMonthStartDate() {
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month - 1, 1);
    return _formatDate(start);
  }

  static String lastMonthEndDate() {
    DateTime now = DateTime.now();
    DateTime end = DateTime(now.year, now.month, 0);
    return _formatDate(end);
  }

  static String currentMonthStartDate() {
    DateTime now = DateTime.now();
    return _formatDate(DateTime(now.year, now.month, 1));
  }

  static String currentMonthEndDate() {
    DateTime now = DateTime.now();
    DateTime firstDayNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    DateTime lastDayCurrentMonth =
    firstDayNextMonth.subtract(const Duration(days: 1));
    return _formatDate(lastDayCurrentMonth);
  }

  static String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String convertToFormat(String inputDate, String outputFormat) {
    final possibleFormats = [
      'dd-MM-yyyy',
      'yyyy-MM-dd',
      'dd/MM/yyyy',
      'yyyy/MM/dd',
      'dd/MMM/yyyy',
      'yyyy/MMM/dd',
      'dd-MMM-yyyy',
      'yyyy-MMM-dd',
    ];

    for (var format in possibleFormats) {
      try {
        final date = DateFormat(format).parseStrict(inputDate);
        return DateFormat(outputFormat).format(date);
      } catch (_) {
        // ignore error, try next format
      }
    }

    return inputDate; // fallback if none matched
  }

  static String currentUTCFormatDate() {
    DateFormat dateFormat = DateFormat(Utils.commonUTCDateFormat);
    String currentDate = dateFormat.format(DateTime.now());
    return currentDate;
  }

  static String currentDate() {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    String currentDate = dateFormat.format(DateTime.now());
    return currentDate;
  }

  static String currentYYYYMMDDDate() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String currentDate = dateFormat.format(DateTime.now());
    return currentDate;
  }

  static String currentYear() {
    DateFormat yearFormat = DateFormat('yyyy');
    String strYear = yearFormat.format(DateTime.now());
    return strYear;
  }

  static String currentMonth() {
    DateFormat monthFormat = DateFormat('MM');
    String strMonth = monthFormat.format(DateTime.now());
    return strMonth;
  }

  static String currentDay() {
    DateFormat dayFormat = DateFormat('dd');
    String strDay = dayFormat.format(DateTime.now());
    return strDay;
  }

  static String formatDate(DateTime dateTime) {
    //DateFormat dateFormat = DateFormat('yyyy/MM/dd');
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    //DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String selected = dateFormat.format(dateTime);
    return selected;
  }

  static String formatDateWithDay(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy, EEEE');
    //DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String selected = dateFormat.format(dateTime);
    return selected;
  }

  static String formatDateWithDDMMYYYY(DateTime dateTime) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String selected = dateFormat.format(dateTime);
    return selected;
  }

  static String yearMMMDDForm(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  static String dateMMMForm(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(date);
  }

  static Future<DateTime?> allDateEnable1(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(int.parse(currentYear()) + 74, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.teal, // ✅ Header background color
            colorScheme: const ColorScheme.light(
              primary: AppColors.teal, // ✅ Selected date color
              onPrimary: AppColors.colorWhite, // ✅ Text color on header
              onSurface: AppColors.colorBlack, // ✅ Text color on surface
            ),
            scaffoldBackgroundColor: AppColors.colorWhite, // ✅ Background color
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.text = formatDate(selected);
    }

    return selected; // Return the selected date
  }

  static Future<DateTime?> previousDateDisable1(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      // Prevents selecting past dates
      lastDate: DateTime(2100, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.teal, // ✅ Header background color
            colorScheme: const ColorScheme.light(
              primary: AppColors.teal, // ✅ Selected date color
              onPrimary: AppColors.colorWhite, // ✅ Text color on header
              onSurface: AppColors.colorBlack, // ✅ Text color on surface
            ),
            scaffoldBackgroundColor: AppColors.colorWhite, // ✅ Background color
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.text = formatDate(selected);
    }

    return selected; // Return the selected date
  }

  static Future<DateTime?> futureDateDisable1(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
      // Prevents selecting future dates
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.teal, // ✅ Header background color
            colorScheme: const ColorScheme.light(
              primary: AppColors.teal, // ✅ Selected date color
              onPrimary: AppColors.colorWhite, // ✅ Text color on header
              onSurface: AppColors.colorBlack, // ✅ Text color on surface
            ),
            scaffoldBackgroundColor: AppColors.colorWhite, // ✅ Background color
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.text = formatDate(selected);
    }

    return selected; // Return the selected date
  }

  static Future<DateTime?> allDateEnable(
    BuildContext context,
    TextEditingController controller,
  ) async {
    // Parse the default financial year start date (01-04-YYYY)
    DateTime defaultDate = DateFormat(
      'dd-MM-yyyy',
    ).parse(firstDayFinancialYear());

    // If user has already selected a date, highlight that. Otherwise, use the default financial year date.
    DateTime initialDate =
        controller.text.isNotEmpty
            ? DateFormat('dd-MM-yyyy').parse(controller.text)
            : defaultDate;

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      // ✅ Highlighted initial date
      firstDate: DateTime(1999),
      lastDate: DateTime(int.parse(currentYear()) + 74, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
            scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            primaryColor: Theme.of(context).colorScheme.primary,
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.text = formatDate(selected); // ✅ Update text field
    }

    return selected; // ✅ Return selected date
  }

  static Future<DateTime?> previousDateDisable(
    BuildContext context,
    TextEditingController controller,
  ) async {
    // Parse the default financial year start date (01-04-YYYY)
    DateTime defaultDate = DateFormat(
      'dd-MM-yyyy',
    ).parse(firstDayFinancialYear());

    // If user has already selected a date, highlight that. Otherwise, use the default financial year date.
    DateTime initialDate =
        controller.text.isNotEmpty
            ? DateFormat('dd-MM-yyyy').parse(controller.text)
            : defaultDate;

    final DateTime? selected = await showDatePicker(
      context: context,
      //initialDate: DateTime.now(),
      initialDate: initialDate,
      firstDate: DateTime.now(),
      // Prevents selecting past dates
      lastDate: DateTime(2100, 12, 31),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.teal, // ✅ Header background color
            colorScheme: const ColorScheme.light(
              primary: AppColors.teal, // ✅ Selected date color
              onPrimary: AppColors.colorWhite, // ✅ Text color on header
              onSurface: AppColors.colorBlack, // ✅ Text color on surface
            ),
            scaffoldBackgroundColor: AppColors.colorWhite, // ✅ Background color
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.text = formatDate(selected);
    }

    return selected; // Return the selected date
  }

  static Future<DateTime?> futureDateDisable(
    BuildContext context,
    TextEditingController controller,
  ) async {
    // Parse the default financial year start date (01-04-YYYY)
    DateTime defaultDate = DateFormat(
      'dd-MM-yyyy',
    ).parse(firstDayFinancialYear());

    // If user has already selected a date, highlight that. Otherwise, use the default financial year date.
    DateTime initialDate =
        controller.text.isNotEmpty
            ? DateFormat('dd-MM-yyyy').parse(controller.text)
            : defaultDate;

    final DateTime? selected = await showDatePicker(
      context: context,
      //initialDate: DateTime.now(),
      initialDate: initialDate,
      firstDate: DateTime(1999),
      lastDate: DateTime.now(),
      // Prevents selecting future dates
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.teal, // ✅ Header background color
            colorScheme: const ColorScheme.light(
              primary: AppColors.teal, // ✅ Selected date color
              onPrimary: AppColors.colorWhite, // ✅ Text color on header
              onSurface: AppColors.colorBlack, // ✅ Text color on surface
            ),
            scaffoldBackgroundColor: AppColors.colorWhite, // ✅ Background color
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.text = formatDate(selected);
    }

    return selected; // Return the selected date
  }

  static String convertDateTimeFormat(
    String inputDate,
    String inputDateFormat,
    String outputDateFormat,
  ) {
    DateFormat inputParser = DateFormat(inputDateFormat);
    DateFormat outputParser = DateFormat(outputDateFormat);
    var date = inputParser.parse(inputDate);
    String outPutData = outputParser.format(date);
    return outPutData;
  }

  static String convertDateFormatInputOutputDate(String inputDate) {
    DateFormat inputParser = DateFormat(Utils.commonUTCDateFormat);
    DateFormat outputParser = DateFormat('dd/MM/yyyy');
    var date = inputParser.parse(inputDate);
    String outPutData = outputParser.format(date);
    return outPutData;
  }

  static String convertDateFormatInputOutputTime(String inputDate) {
    DateFormat inputParser = DateFormat('dd/MM/yyyy HH:mm');
    DateFormat outputParser = DateFormat('HH:mm');
    var date = inputParser.parse(inputDate);
    String outPutData = outputParser.format(date);
    return outPutData;
  }

  static String firstDayOfYear() {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime firstDay = DateTime(DateTime.now().year, 1, 1);
    return dateFormat.format(firstDay);
  }

  static String lastDayOfYear() {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateTime lastDay = DateTime(DateTime.now().year, 12, 31);
    return dateFormat.format(lastDay);
  }

  static String firstDayFinancialYear() {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime now = DateTime.now();

    // If today's date is before April 1, use the previous year's April 1.
    int startYear = now.month < 4 ? now.year - 1 : now.year;

    DateTime firstDay = DateTime(startYear, 4, 1);
    return dateFormat.format(firstDay);
  }

  static String lastDayFinancialYear() {
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime now = DateTime.now();

    // If today's date is before April 1, use this year's March 31. Otherwise, use next year's.
    int endYear = now.month < 4 ? now.year : now.year + 1;

    DateTime lastDay = DateTime(endYear, 3, 31);
    return dateFormat.format(lastDay);
  }
}
