import 'package:enthem2/constants/page_padding.dart';
import 'package:enthem2/interfaces/user.dart';
import 'package:enthem2/screens/auth/geolocation_screen.dart';
import 'package:enthem2/services/debug_console.dart';
import 'package:enthem2/widgets/auth_continue_button.dart';
import 'package:enthem2/widgets/gender_widget.dart';
import 'package:flutter/material.dart';

class GenderPage extends StatefulWidget {
  static const routeID = "/genderpage";

  final UserInterface userInterface;

  const GenderPage({
    required this.userInterface,
    super.key,
  });

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  late Gender selected;
  static const String filename = "gender_screen.dart";

  @override
  void initState() {
    selected = Gender.male;
    super.initState();
  }

  void navigateToInterestsPage({bool selectedNull = false}) {
    widget.userInterface.gender = selectedNull ? null : selected.name;
    debugData(widget.userInterface.toString(), filename);
    Navigator.of(context).pushNamed(
      GeoLocationPage.routeID,
      arguments: widget.userInterface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthContinueButton(
        des:
            "Your gender won't be shown to others. It is only used to help filter matches.",
        onTap: navigateToInterestsPage,
        isDisabled: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: kPagePadding.copyWith(
            top: 20,
            left: 35,
            right: 35,
            bottom: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose gender",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "Choose your gender identity",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              GenderWidget(
                onclick: () {
                  setState(() {
                    selected = Gender.male;
                  });
                },
                isSelected: Gender.male == selected,
                title: 'Male',
                icon: Icons.male,
              ),
              GenderWidget(
                isSelected: Gender.female == selected,
                onclick: () {
                  setState(() {
                    selected = Gender.female;
                  });
                },
                title: 'Female',
                icon: Icons.female,
              ),
              GenderWidget(
                isSelected: Gender.others == selected,
                onclick: () {
                  setState(() {
                    selected = Gender.others;
                  });
                },
                title: 'Others',
                icon: Icons.transgender,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => navigateToInterestsPage(selectedNull: true),
                  child: const Text(
                    "I'd prefer not to say",
                    style: TextStyle(
                      fontFamily: "Exo2",
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
