import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String currency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₱', decimalDigits: 2);
    return formatter.format(amount);
  }

  static String date(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String dateShort(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String dateRange(DateTime start, DateTime end) {
    return '${dateShort(start)} - ${date(end)}';
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date.toString();
  }
}
