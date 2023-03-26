import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:the_dig_app/providers/dig_firebase_provider.dart';
import 'package:the_dig_app/routes/routes.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:the_dig_app/services/local_notification_service.dart';
import 'firebase_options.dart';

// FlutterFire's Firebase Cloud Messaging plugin
import 'package:firebase_messaging/firebase_messaging.dart';

// core Flutter primitives
import 'package:flutter/foundation.dart';

//Add stream controller
import 'package:rxdart/rxdart.dart';

// used to pass messages from event handler to the UI
final _messageStreamController = BehaviorSubject<RemoteMessage>();

//Define the background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LocalNotificationService.initialize();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(
      persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  //Request permission
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // if (kDebugMode) {
    //   print('Handling a foreground message: ${message.messageId}');
    //   print('Message data: ${message.data}');
    //   print('Message notification: ${message.notification?.title}');
    //   print('Message notification: ${message.notification?.body}');
    // }
    LocalNotificationService.display(message);

    _messageStreamController.sink.add(message);
  });

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: routes,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DigFirebaseProvider>(
      create: (_) => DigFirebaseProvider(Firebase.app()),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.teal,
            textTheme: const TextTheme(
              labelSmall: TextStyle(color: Colors.white, fontSize: 22),
              headlineMedium: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 24),
              headlineSmall: TextStyle(fontSize: 22.0),
              bodyLarge: TextStyle(fontSize: 20.0),
              bodyMedium: TextStyle(fontSize: 18.0),
              bodySmall: TextStyle(fontSize: 16.0),
            )),
        routerConfig: _router,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DIG"),
      ),
    );
  }
}
