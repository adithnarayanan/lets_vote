import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:lets_vote/ballot.dart';
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

void showScheduledNotification(
    String type, String content, DateTime scheduledTime, int channelId) async {
  await _scheduledNotification(type, content, scheduledTime, channelId);
}

Future<void> _scheduledNotification(
    String type, String content, DateTime scheduledTime, int channelId) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel $channelId ID',
      'channel $channelId Name',
      'channel $channelId description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'test ticker');

  var iOSChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecfics =
      NotificationDetails(androidPlatformChannelSpecifics, iOSChannelSpecifics);

  await flutterLocalNotificationsPlugin.schedule(
      channelId, type, content, scheduledTime, platformChannelSpecfics);
}

void cancelScheduleNotification(int channelId) async {
  await flutterLocalNotificationsPlugin.cancel(channelId);
}

void cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

void createBallotNotifications() async {
  Box ballotBox = Hive.box<Ballot>('ballotBox');
  for (var x = 0; x < ballotBox.length; x++) {
    Ballot ballot = ballotBox.getAt(x);
    if (DateTime.now().isBefore(ballotBox.getAt(x).date)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int firstAlert = prefs.getInt('firstAlert') ?? 7;
      int secondAlert = prefs.getInt('secondAlert') ?? 7;

      showScheduledNotification(
          'Reminder',
          'Registration Deadline for ${ballot.name} is just $firstAlert Days Away',
          //ballot.deadline.subtract(new Duration(days: firstAlert)),
          DateTime.now().add(Duration(seconds: firstAlert)),
          x);

      showScheduledNotification(
          'Reminder',
          '${ballot.name} is just $secondAlert Days Away!',
          //ballot.date.subtract(new Duration(days: firstAlert)),
          DateTime.now().add(Duration(seconds: secondAlert + 20)),
          x + ballotBox.length);
    }
  }
}
