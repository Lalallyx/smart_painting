class TimeUtils {
  static String formatTime(int hour, int minute, int second) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}
