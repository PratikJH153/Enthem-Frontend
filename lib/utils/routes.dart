import 'package:enthem2/models/user.dart';
import 'package:enthem2/screens/profile/edit_interests_screen.dart';
import 'package:enthem2/screens/profile/edit_profile_screen.dart';

import '/interfaces/user.dart';
import '/screens/auth/dob_screen.dart';
import '/screens/auth/gender_screen.dart';
import '/screens/auth/geolocation_screen.dart';
import '/screens/auth/interests_screen.dart';
import '/screens/auth/onboard_screen.dart';
import '/screens/auth/splash_screen.dart';
import '/screens/auth/username_screen.dart';
import '/screens/auth/wrapper.dart';
import '/screens/home/UserEntryPage.dart';
import '/screens/home/find_friends_screen.dart';
import '/screens/home/home_screen.dart';
import '/screens/home/messages_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/home/group_chat_screen.dart';
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
        final UserInterface userInterface = settings.arguments as UserInterface;
        return MaterialPageRoute(
          builder: (context) => InterestsPage(
            userInterface: userInterface,
          ),
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
      case EditProfilePage.routeID:
        return MaterialPageRoute(
          builder: (context) => const EditProfilePage(),
        );
      case EditInterestsPage.routeID:
        final UserModel userModel = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (context) => EditInterestsPage(
            user: userModel,
          ),
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
