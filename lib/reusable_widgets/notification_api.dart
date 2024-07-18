import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotificationService{
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    const AndroidInitializationSettings androidInitializationSettings = 
        AndroidInitializationSettings('@drawable/ic_stat_add_alert');



    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await _localNotificationService.initialize(settings, );

  }

  Future<NotificationDetails> _notificationdetails()async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channelId', "channelName", channelDescription: 'channelDescription',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true);


    return NotificationDetails(
        android: androidNotificationDetails
    );
  }
  Future<void> showNotification({
    required int id,
    required String title,
    required String body
    })async {
    final details = await _notificationdetails();
    _localNotificationService.show(id, title, body, details);
  }
  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload){
    print("id $id");
  }
  void onSelectNotification(String? payload){
    print('payload $payload');
  }
}