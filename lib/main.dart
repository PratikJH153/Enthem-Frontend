import 'package:enthem2/screens/auth/wrapper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'logic/provider/friend_provider.dart';
import 'logic/provider/rooms_provider.dart';
import 'logic/provider/user_provider.dart';
import 'utils/routes.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Restrict orientation to portrait mode
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // Set the status bar color and brightness
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarBrightness: Brightness.light,
  ));

  // Load environment variables from the .env file
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FriendProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
        ChangeNotifierProvider(create: (_) => RoomsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        title: "Enthem",
        theme: themeData,
        initialRoute: InternetWrapper.routeID,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (ctx) => const Scaffold(
            body: Center(
              child: Text("Error 404 Not Found"),
            ),
          ),
        ),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
