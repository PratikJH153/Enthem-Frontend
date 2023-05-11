import '../../logic/provider/global_data_provider.dart';
import '/logic/provider/user_provider.dart';
import '/helper/display_user_dp.dart';
import '/screens/home/home_screen.dart';
import '/utils/encryption.dart';
import '/widgets/custom_dialog_box.dart';
import '/widgets/dialog_box_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/constants/page_padding.dart';
import '/database/repositories/room_api_repository.dart';
import '/firebase/sign_in_method.dart';
import '/helper/error_constants.dart';
import '/logic/repositories/user_api_repository.dart';
import '/models/user.dart';
import '/screens/auth/onboard_screen.dart';
import '/theme/theme.dart';
import '/utils/location_permission.dart';
import '/widgets/custom_snackbar.dart';
import '/widgets/loading_widget.dart';
import '/widgets/profile_rooms.dart';
import '/widgets/settings_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/services/debug_console.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const routeID = "/profilepage";

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final AuthService _authService = AuthService();
  final UserAPIRepository _userAPIRepository = UserAPIRepository();
  static const String filename = "profile_screen.dart";
  bool _isSettingsLoading = false;
  bool _isLocationLoading = false;
  Position? _currentPosition;
  late int index1;
  UserModel? _user;

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
      await _userAPIRepository.updateUser({
        "id": _user?.id,
        "latitude": _currentPosition?.latitude,
        "longitude": _currentPosition?.longitude,
      });
      setState(() {
        _user!.updateLocation(
            _currentPosition?.latitude, _currentPosition?.longitude);
      });

      await GlobalDataProvider.resetUserDataProvider(context);
    } catch (err) {
      errorSnackBar(context: context, error: ErrorState.serverError);
    }
  }

  @override
  void initState() {
    UserDataProvider provider = context.read<UserDataProvider>();
    _user = provider.userData;
    _usernameController.text = _user!.username!;
    index1 = (_user!.interests!.length ~/ 2).floor();

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void logout(BuildContext context) {
    _authService.signOut().then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        OnboardPage.routeID,
        (route) => false,
      );
    }).catchError((err) {
      debugError(err, filename);
    });
  }

  void deleteAccount() async {
    try {
      setState(() {
        _isSettingsLoading = true;
      });
      bool isDeleted = await _userAPIRepository.deleteUser({
        "id": encrypt(
          _user!.id!,
          dotenv.env["SECRET_KEY"]!,
        ),
      });
      if (isDeleted) {
        await _authService.signOut();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            OnboardPage.routeID,
            (route) => false,
          );
        } else {
          setState(() {
            _isSettingsLoading = false;
          });
          errorSnackBar(
            context: context,
            error: ErrorState.otherError,
          );
        }
      }
    } catch (err) {
      debugError(err.toString(), filename);
      errorSnackBar(
        context: context,
        error: ErrorState.serverError,
      );
      setState(() {
        _isSettingsLoading = false;
      });
      rethrow;
    }
  }

  Widget bottomPage() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 30,
        ),
        color: backgroundColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Settings",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "Poppins",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              SettingsButton(
                title: "Edit Profile",
                onTap: () {},
              ),
              // SettingsButton(
              //   title: "Notification Settings",
              //   onTap: () {},
              // ),
              const SizedBox(
                height: 30,
              ),
              SettingsButton(
                title: "What's New",
                onTap: () {},
              ),
              SettingsButton(
                title: "FAQ/Contact Us",
                onTap: () {},
              ),
              SettingsButton(
                title: "Community Guidelines",
                onTap: () {},
              ),
              SettingsButton(
                title: "Terms of Service",
                onTap: () {},
              ),
              SettingsButton(
                title: "Privacy Policy",
                onTap: () {},
              ),
              const SizedBox(
                height: 30,
              ),
              _isSettingsLoading
                  ? const Center(
                      child: LoadingWidget(),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(66, 59, 59, 59),
                              foregroundColor: Colors.red,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () {
                              showCustomDialog(
                                context,
                                DialogBoxWidget(
                                  title: "Logout",
                                  des:
                                      "Are you sure want to logout of your account? We will miss you!",
                                  firstButton: "Yes",
                                  secondButton: "Cancel",
                                  firstOnTap: () {
                                    logout(context);
                                  },
                                  secondOnTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                              );
                            },
                            child: const Center(
                              child: Text("Logout"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(66, 59, 59, 59),
                              foregroundColor: Colors.red,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              showCustomDialog(
                                context,
                                DialogBoxWidget(
                                  title: "Delete Account",
                                  des:
                                      "Are you sure want to delete your account permanently?",
                                  firstButton: "Yes",
                                  secondButton: "Cancel",
                                  firstOnTap: () {
                                    deleteAccount();
                                  },
                                  secondOnTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                              );
                            },
                            child: const Center(
                              child: Text("Delete Account Permanently"),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          )
        ]),
      ),
    );
  }

  // Widget usernameChange() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 24,
  //       vertical: 30,
  //     ),
  //     margin: const EdgeInsets.only(top: 120),
  //     color: backgroundColor,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(
  //           height: 5,
  //         ),
  //         const Text(
  //           "Change your username",
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontFamily: "Poppins",
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 15,
  //         ),
  //         Container(
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(10),
  //             ),
  //             color: Colors.black12,
  //           ),
  //           child: TextField(
  //             controller: _usernameController,
  //             decoration: const InputDecoration(
  //               contentPadding: EdgeInsets.only(left: 20),
  //               hintText: "Username",
  //               border: InputBorder.none,
  //             ),
  //           ),
  //         ),
  //         const Spacer(),
  //         DoneButton(
  //           title: "Done",
  //           isDisabled: false,
  //           onTap: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    UserDataProvider userDataProvider = context.watch<UserDataProvider>();
    List rooms = userDataProvider.rooms;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeID, (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                errorSnackBar(
                    context: context, error: ErrorState.workingFeature);
              },
              icon: const Icon(
                CupertinoIcons.share,
                size: 25,
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return bottomPage();
                    });
              },
              icon: const Icon(
                CupertinoIcons.settings,
                size: 25,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: kPagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 37, 36, 37),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          displayUserPicture(_user!.username!),
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      Text(
                        _user!.username!,
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        _user!.email!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          // TextButton(
                          //   onPressed: () {},
                          //   style: TextButton.styleFrom(
                          //     padding: EdgeInsets.zero,
                          //     textStyle: const TextStyle(
                          //       fontSize: 16,
                          //     ),
                          //   ),
                          //   child: const Text(
                          //     "Add a bio",
                          //   ),
                          // ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          _isLocationLoading
                              ? const Center(
                                  child: LoadingWidget(),
                                )
                              : TextButton(
                                  onPressed: () async {
                                    await _getCurrentPosition()
                                        .then((value) async {
                                      debugData(_currentPosition, filename);
                                      await updateUser();
                                    }).catchError((err) {});
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    "Update my location",
                                  ),
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Interests",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white54,
                        ),
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
                              _user!.interests![index],
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
                        itemCount: _user!.interests!.length - index1,
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
                              _user!.interests![index + index1],
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
                Padding(
                  padding: kPagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Rooms",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            child: const Text(
                              "View All",
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: rooms.isEmpty
                            ? const Text("No rooms created yet")
                            : ListView.builder(
                                itemCount: rooms.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return ProfileRoomsWidget(room: rooms[index]);
                                },
                              ),
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
