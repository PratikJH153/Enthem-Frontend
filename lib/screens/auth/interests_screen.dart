import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/helper/shared_pref.dart';
import 'package:enthem2frontend/logic/repositories/user_api_repository.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/home/home_screen.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/widgets/auth_continue_button.dart';
import 'package:enthem2frontend/widgets/shaded_list_widget.dart';
import 'package:flutter/material.dart';
import '../../constants/interests.dart';

class InterestsPage extends StatefulWidget {
  static const routeID = "/interestspage";

  final UserModel? userModel;

  const InterestsPage({this.userModel, super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  static const String filename = "interests_screen.dart";
  List<String> selectedInterests = [];
  final UserAPIRepository _apiRepository = UserAPIRepository();

  void navigateToHomePage() async {
    debugData(widget.userModel.toString(), filename);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  void addInterests() async {
    try {
      if (selectedInterests.isEmpty) {
        return errorSnackBar(
          context: context,
          error: ErrorState.interestsNotAdded,
        );
      }
      late final String id;
      if (widget.userModel == null) {
        id = _apiRepository.getUserID();
      } else {
        id = widget.userModel!.id!;
      }
      final data = await _apiRepository.addInterests(
        id,
        selectedInterests,
      );
      if (data) {
        await RegisterUser.setBool(true);
        navigateToHomePage();
      } else {
        await RegisterUser.setBool(false);
        if (context.mounted) {
          errorSnackBar(context: context, error: ErrorState.serverError);
        }
      }
    } catch (err) {
      debugError(err.toString(), filename);
      errorSnackBar(context: context, error: ErrorState.serverError);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthContinueButton(
        isDisabled: false,
        onTap: addInterests,
      ),
      body: SafeArea(
        child: Padding(
          padding: kPagePadding.copyWith(
            top: 50,
            left: 35,
            right: 35,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Time to add some interests",
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
                  "Choose at least 5 interests",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  child: ShadedList(
                    widget: ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 100,
                        top: 20,
                      ),
                      itemCount: interests.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              interests[index]["name"].toString(),
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                                top: 20,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 4.0,
                                  children: interests[index]["interests"]
                                      .map<Widget>(
                                        (e) => filterChip(
                                          e,
                                          selectedInterests.contains(e),
                                          (isSelected) {
                                            setState(() {
                                              if (isSelected == false) {
                                                selectedInterests.remove(e);
                                              } else {
                                                selectedInterests.add(e);
                                              }
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterChip(
    String chipName,
    bool isSelected,
    Function onTap,
  ) {
    return FilterChip(
      label: Text(chipName),
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.white,
        fontSize: 13.0,
        fontWeight: FontWeight.bold,
      ),
      selected: isSelected,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      backgroundColor: const Color.fromARGB(19, 237, 237, 237),
      onSelected: (selected) => onTap(selected),
      selectedColor: Colors.white,
      checkmarkColor: Colors.black,
    );
  }
}
