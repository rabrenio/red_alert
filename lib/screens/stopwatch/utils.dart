(int, int, int) extractTime(int totalMilliseconds) {
  int minutes = (totalMilliseconds / 60000).floor(); // 1 minute is 60,000
  int seconds = ((totalMilliseconds % 60000) / 1000)
      .floor(); // 1 second is 1000 milliseconds
  int milliseconds = totalMilliseconds % 1000; // remaining milliseconds

  return (minutes, seconds, milliseconds);
}

String getStringTime(int time) {
  var timeStr = time.toString();

  if (timeStr.length == 1) return timeStr.padLeft(2, '0');
  return timeStr.substring(0, 2);
}

String getReadableTime(List<int> timeList) {
  return timeList.map(getStringTime).join(':');
}
