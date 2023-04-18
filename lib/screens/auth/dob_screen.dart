import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/interfaces/user.dart';
import 'package:enthem2frontend/screens/auth/gender_screen.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/widgets/auth_continue_button.dart';
import 'package:enthem2frontend/widgets/dob_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helper/check_dob.dart';

class DOBPage extends StatefulWidget {
  static const routeID = "/dobpage";

  final UserInterface userInterface;

  const DOBPage({required this.userInterface, super.key});

  @override
  State<DOBPage> createState() => _DOBPageState();
}

class _DOBPageState extends State<DOBPage> {
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const String filename = "dob_screen.dart";

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void navigateToGenderScreen() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      final String timeString =
          "${_dayController.text}.${_monthController.text}.${_yearController.text}";
      final DateFormat df = DateFormat("dd.MM.yyyy");
      try {
        final DateTime dob = df.parseStrict(timeString);
        final int age = calculateAge(dob);
        if (age > 14 && age < 100) {
          widget.userInterface.age = age;
          debugData(widget.userInterface.toString(), filename);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GenderPage(
                userInterface: widget.userInterface,
              ),
            ),
          );
        } else {
          errorSnackBar(context: context, error: ErrorState.ageProblem);
        }
      } catch (err) {
        errorSnackBar(context: context, error: ErrorState.dobWrong);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthContinueButton(
        des:
            "Make sure to put the right birth date. You won't be able to change it later.",
        onTap: navigateToGenderScreen,
        isDisabled: !isNotDateEmpty(
          month: _monthController.text,
          day: _dayController.text,
          year: _yearController.text,
        ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "When's your birthday?",
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
                  "You must be 14+ to use Enthem",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: dobField(
                              controller: _dayController,
                              max: 2,
                              hintText: "DD",
                              onTap: (val) {
                                if (val.length == 2) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            child: dobField(
                              controller: _monthController,
                              max: 2,
                              hintText: "MM",
                              onTap: (val) {
                                if (val.length == 2) {
                                  FocusScope.of(context).nextFocus();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            child: dobField(
                              controller: _yearController,
                              max: 4,
                              hintText: "YYYY",
                              onTap: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
