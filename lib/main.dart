import 'package:enthem2frontend/logic/bloc/internet/internet_bloc.dart';
import 'package:enthem2frontend/logic/bloc/user/user_bloc.dart';
import 'package:enthem2frontend/screens/auth/wrapper.dart';
import 'package:enthem2frontend/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarBrightness: Brightness.light,
  ));
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetBloc>(
          create: (_) => InternetBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(),
        ),
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
