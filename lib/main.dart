import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter_app/features/news/domain/usecases/get_all_articles.dart';
import 'package:news_flutter_app/features/news/presentation/providers/news_provider.dart';
import 'package:news_flutter_app/features/news/presentation/screens/news_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'core/services/notification_service.dart';
import 'di/injector.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message: ${message.messageId}');
}

Future<void> requestNotificationPermissions() async {
  final status = await Permission.notification.status;
  print('Notification status BEFORE request: $status');
  if (!status.isGranted) {
    final result = await Permission.notification.request();

    print('Notification status AFTER request: $result');

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await requestNotificationPermissions();
  NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NewsProvider(sl<GetAllArticles>())..loadInitial(),
        )
      ],
      child: MaterialApp(
        navigatorKey: NotificationService.navigatorKey,
        title: 'News',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const NewsScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
