import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/helper/helpers.dart';
import 'package:enthem2frontend/interfaces/user.dart';
import 'package:enthem2frontend/logic/repositories/user_api_repository.dart';
import 'package:enthem2frontend/screens/auth/dob_screen.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/widgets/auth_continue_button.dart';
import 'package:flutter/material.dart';

class UsernamePage extends StatefulWidget {
  static const routeID = "/usernamepage";

  final UserInterface userInterface;

  const UsernamePage({required this.userInterface, super.key});

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final UserAPIRepository _apiRepository = UserAPIRepository();
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const String filename = "userdata_screen.dart";

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void navigateToGenderScreen() async {
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (!await checkUsernameExists()) {
        widget.userInterface.username = _usernameController.text;
        debugData(widget.userInterface.toString(), filename);
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DOBPage(
                userInterface: widget.userInterface,
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          errorSnackBar(context: context, error: ErrorState.usernameExists);
        }
      }
    }
  }

  Future<bool> checkUsernameExists() async {
    try {
      final data =
          await _apiRepository.checkUsernameExists(_usernameController.text);
      return data;
    } catch (err) {
      debugError(err.toString(), filename);
      errorSnackBar(context: context, error: ErrorState.serverError);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AuthContinueButton(
        des: "This appears on your Enthem profile. You can change it later.",
        isDisabled: _usernameController.text.trim().isEmpty,
        onTap: navigateToGenderScreen,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
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
                  "What's your name?",
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
                    "Choose a display name, this is what your friends on Enthem will see",
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
                      TextFormField(
                        controller: _usernameController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Colors.white38,
                          ),
                          hintText: "Your username",
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                        validator: (val) {
                          if (val!.trim().isNotEmpty &&
                              3 < val.trim().length &&
                              val.trim().length < 16) {
                            final name = validateName(val);
                            return name;
                          }
                          return "Atleast 4-15 characters required";
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
