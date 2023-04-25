import 'package:enthem2frontend/interfaces/user.dart';
import 'package:enthem2frontend/screens/auth/dob_screen.dart';
import 'package:enthem2frontend/screens/auth/gender_screen.dart';
import 'package:enthem2frontend/screens/auth/geolocation_screen.dart';
import 'package:enthem2frontend/screens/auth/interests_screen.dart';
import 'package:enthem2frontend/screens/auth/onboard_screen.dart';
import 'package:enthem2frontend/screens/auth/splash_screen.dart';
import 'package:enthem2frontend/screens/auth/username_screen.dart';
import 'package:enthem2frontend/screens/auth/wrapper.dart';
import 'package:enthem2frontend/screens/home/UserEntryPage.dart';
import 'package:enthem2frontend/screens/home/find_friends_screen.dart';
import 'package:enthem2frontend/screens/home/home_screen.dart';
import 'package:enthem2frontend/screens/home/messages_screen.dart';
import 'package:enthem2frontend/screens/profile/profile_screen.dart';
import 'package:enthem2frontend/screens/home/group_chat_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case InternetWrapper.routeID:
        return MaterialPageRoute(builder: (context) => const InternetWrapper());
      case HomePage.routeID:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case OnboardPage.routeID:
        return MaterialPageRoute(
          builder: (context) => const OnboardPage(),
        );
      case UserEntryPage.routeID:
        return MaterialPageRoute(
          builder: (context) => const UserEntryPage(),
        );
      case UsernamePage.routeID:
        final UserInterface userInterface = settings.arguments as UserInterface;
        return MaterialPageRoute(
          builder: (context) => UsernamePage(
            userInterface: userInterface,
          ),
        );
      case GenderPage.routeID:
        final UserInterface userInterface = settings.arguments as UserInterface;
        return MaterialPageRoute(
          builder: (context) => GenderPage(
            userInterface: userInterface,
          ),
        );
      case InterestsPage.routeID:
        return MaterialPageRoute(
          builder: (context) => const InterestsPage(),
        );
      case GeoLocationPage.routeID:
        final UserInterface userInterface = settings.arguments as UserInterface;
        return MaterialPageRoute(
          builder: (context) => GeoLocationPage(
            userInterface: userInterface,
          ),
        );
      case FindFriendsPage.routeID:
        return MaterialPageRoute(
          builder: (context) => const FindFriendsPage(),
        );
      case GroupChatPage.routeID:
        return MaterialPageRoute(
          builder: (context) => const GroupChatPage(),
        );
      case ProfilePage.routeID:
        return MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        );
      case DOBPage.routeID:
        final UserInterface userInterface = settings.arguments as UserInterface;
        return MaterialPageRoute(
          builder: (context) => DOBPage(
            userInterface: userInterface,
          ),
        );
      case SplashScreen.routeID:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case MessagesPage.routeID:
        return MaterialPageRoute(
          builder: (context) => const MessagesPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text("Page not found"),
            ),
          ),
        );
    }
  }
}
