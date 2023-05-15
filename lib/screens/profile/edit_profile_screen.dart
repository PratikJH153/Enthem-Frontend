import 'package:enthem2frontend/constants/constants.dart';
import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/helper/error_constants.dart';
import 'package:enthem2frontend/helper/helpers.dart';
import 'package:enthem2frontend/logic/repositories/user_api_repository.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/home/home_screen.dart';
import 'package:enthem2frontend/screens/profile/edit_interests_screen.dart';
import 'package:enthem2frontend/services/debug_console.dart';
import 'package:enthem2frontend/utils/encryption.dart';
import 'package:enthem2frontend/utils/location_permission.dart';
import 'package:enthem2frontend/widgets/auth_continue_button.dart';
import 'package:enthem2frontend/widgets/custom_snackbar.dart';
import 'package:enthem2frontend/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  static const routeID = "/editprofilepage";
  const EditProfilePage({
    required this.user,
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const String filename = "edit_profile_screen.dart";
  final UserAPIRepository _userAPIRepository = UserAPIRepository();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLocationLoading = false;
  Position? _currentPosition;
  late int index1;
  bool _isLoading = false;

  @override
  void initState() {
    _usernameController.text = widget.user.username!;
    index1 = (widget.user.interests!.length ~/ 2).floor();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      _isLocationLoading = true;
    });
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) {
      setState(() {
        _isLocationLoading = false;
      });
      return;
    }
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        _isLocationLoading = false;
      });
      showSnackBar(
        context: context,
        status: "success",
        title: "Location updated successfully!",
        des: "",
      );
    }).catchError((e) {
      debugError(e.toString(), filename);
      errorSnackBar(context: context, error: ErrorState.errorLocation);
      setState(() {
        _isLocationLoading = false;
      });
    });
  }

  Future<void> updateUser() async {
    try {
      if (widget.user.username != _usernameController.text.trim()) {
        final checkUsernameExists = await _userAPIRepository
            .checkUsernameExists(_usernameController.text.trim());
        if (checkUsernameExists) {
          if (context.mounted) {
            errorSnackBar(context: context, error: ErrorState.usernameExists);
          }
        }
        final data = await _userAPIRepository.updateUser({
          "id": encrypt(widget.user.id!, env["SECRET_KEY"]!),
          "username": _usernameController.text.trim(),
        });
        if (data) {
          if (context.mounted) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(HomePage.routeID, (route) => false);
          }
        } else {
          if (context.mounted) {
            errorSnackBar(
              context: context,
              error: ErrorState.serverError,
            );
          }
        }
      } else {
        Navigator.of(context).pop();
      }
    } catch (err) {
      errorSnackBar(context: context, error: ErrorState.serverError);
    }
  }

  Future<void> updateLocation() async {
    setState(() {
      _isLoading = true;
    });
    if (_currentPosition != null) {
      try {
        await _userAPIRepository.updateUser({
          "id": encrypt(widget.user.id!, env["SECRET_KEY"]!),
          "latitude": _currentPosition?.latitude,
          "longitude": _currentPosition?.longitude,
        });
        setState(() {
          widget.user.updateLocation(
              _currentPosition?.latitude, _currentPosition?.longitude);
          _isLoading = false;
        });
      } catch (err) {
        errorSnackBar(context: context, error: ErrorState.serverError);
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> disableLocation() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _userAPIRepository.updateUser({
        "id": encrypt(widget.user.id!, env["SECRET_KEY"]!),
        "latitude": -90.0,
        "longitude": 0,
      });
      setState(() {
        widget.user.updateLocation(-90.0, 0);
        _isLoading = false;
      });
    } catch (err) {
      errorSnackBar(context: context, error: ErrorState.serverError);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isLoading
          ? const LoadingWidget()
          : AuthContinueButton(
              title: "Edit",
              des: "Your profile will be updated as required",
              onTap: updateUser,
              isDisabled: false,
            ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: kPagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                _isLocationLoading
                    ? const Center(
                        child: LoadingWidget(),
                      )
                    : Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await _getCurrentPosition().then((value) async {
                                debugData(_currentPosition, filename);
                                await updateLocation();
                              }).catchError((err) {});
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            child: const Text(
                              "Update location",
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          TextButton(
                            onPressed: () async {
                              await disableLocation();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            child: const Text(
                              "Disable location",
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      "Interests",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white54,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          EditInterestsPage.routeID,
                          arguments: widget.user,
                        );
                      },
                      child: const Text("Edit Interests"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 35,
                child: ListView.builder(
                  itemCount: index1,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        color: Colors.white24,
                      ),
                      child: Text(
                        widget.user.interests![index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 35,
                child: ListView.builder(
                  itemCount: widget.user.interests!.length - index1,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 15),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                        color: Colors.white24,
                      ),
                      child: Text(
                        widget.user.interests![index + index1],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
