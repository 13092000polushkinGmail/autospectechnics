abstract class DateFormatter {
  static String getFormattedDate(DateTime? date) {
    if (date == null) return '';
    final unformattedString = date.toString().split(' ')[0];
    final resultString = unformattedString.substring(8, 10) +
        '.' +
        unformattedString.substring(5, 7) +
        '.' +
        unformattedString.substring(0, 4);
    return resultString;
  }

  static DaysInfo? getDaysInfo(DateTime? startDate, DateTime? finishDate) {
    if (startDate == null || finishDate == null) {
      return null;
    }
    final _startDate = DateTime(startDate.year, startDate.month, startDate.day);
    final _finishDate =
        DateTime(finishDate.year, finishDate.month, finishDate.day);
    final todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    int intDaysAmount;
    String daysText;
    if (todayDate.isBefore(_startDate)) {
      intDaysAmount = todayDate.difference(_startDate).inDays.abs();
      daysText = 'До начала';
    } else if (todayDate.isBefore(_finishDate)) {
      intDaysAmount = todayDate.difference(_finishDate).inDays.abs();
      daysText = 'До окончания';
    } else {
      intDaysAmount = _finishDate.difference(todayDate).inDays.abs();
      daysText = 'С момента завершения';
    }

    String daysWord;
    if (10 < (intDaysAmount % 100) && (intDaysAmount % 100) < 20) {
      daysWord = 'дней';
    } else if (intDaysAmount % 10 == 1) {
      daysWord = 'день';
    } else if (1 < (intDaysAmount % 10) && (intDaysAmount % 10) < 5) {
      daysWord = 'дня';
    } else {
      daysWord = 'дней';
    }
    final daysAmount = intDaysAmount.toString() + ' $daysWord';
    return DaysInfo(daysText: daysText, daysAmount: daysAmount);
  }
}

class DaysInfo {
  final String daysText;
  final String daysAmount;
  DaysInfo({
    required this.daysText,
    required this.daysAmount,
  });
}
