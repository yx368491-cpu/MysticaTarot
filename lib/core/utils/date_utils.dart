/// Date-related utility functions
class DateUtils {
  DateUtils._();

  /// Format date to YYYY-MM-DD string
  static String toDateString(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Get today's date as YYYY-MM-DD string
  static String get todayString => toDateString(DateTime.now());

  /// Get date seed for daily card generation
  static int get dateSeed {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Format time string (HH:mm) to DateTime
  static DateTime? timeStringToDateTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
