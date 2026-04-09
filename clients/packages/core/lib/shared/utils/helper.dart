abstract class Helper {
  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String formatDate(String date) {
    final formattedDate = DateTime.parse(date);
    return '${months[formattedDate.month - 1]} ${formattedDate.day}, ${formattedDate.year}';
  }
}
