import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/home/home_screen.dart';
import 'package:enthem2frontend/screens/room/near_rooms.dart';
import 'package:enthem2frontend/screens/room/world_rooms.dart';
import 'package:enthem2frontend/theme/theme.dart';
import 'package:enthem2frontend/views/search_rooms_view.dart';
import 'package:enthem2frontend/widgets/custom_dialog_box.dart';
import 'package:enthem2frontend/widgets/dialog_box_widget.dart';
import 'package:enthem2frontend/widgets/explore_interest_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  static const routeID = "/groupchatpage";
  final UserModel? user;
  const GroupChatPage({this.user, super.key});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  static const String filename = "group_chat_screen.dart";
  late List<Room> roomsList;
  late final PageController _pageController;
  int pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  void bottomTapped(int index) {
    setState(() {
      pageIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> roomPagesButton() {
    return widget.user!.isLocationGiven
        ? [
            ExploreInterestWidget(
              iconData: CupertinoIcons.location_circle_fill,
              title: "Near",
              isSelected: pageIndex == 0,
              color: buttonColor,
              onTap: () {
                bottomTapped(0);
              },
            ),
            ExploreInterestWidget(
              iconData: CupertinoIcons.globe,
              title: "World",
              isSelected: pageIndex == 1,
              color: Colors.blue,
              onTap: () {
                bottomTapped(1);
              },
            ),
          ]
        : [
            ExploreInterestWidget(
              iconData: CupertinoIcons.globe,
              title: "World",
              isSelected: pageIndex == 0,
              color: Colors.blue,
              onTap: () {
                bottomTapped(0);
              },
            ),
            ExploreInterestWidget(
              iconData: CupertinoIcons.location_circle_fill,
              title: "Near",
              isSelected: pageIndex == 1,
              color: buttonColor,
              onTap: () => showCustomDialog(
                context,
                DialogBoxWidget(
                  title: "Location Required",
                  des:
                      "To access Nearby, please share your location by allowing it in profile",
                  firstButton: "Ok",
                  secondButton: "Cancel",
                  firstOnTap: () {
                    Navigator.of(context).pop(true);
                  },
                  secondOnTap: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
            ),
          ];
  }

  List<Widget> roomPages() {
    return widget.user!.isLocationGiven
        ? [
            NearRoomsPage(
              user: widget.user!,
            ),
            WorldRoomsPage(
              user: widget.user!,
            )
          ]
        : [
            WorldRoomsPage(
              user: widget.user!,
            ),
            NearRoomsPage(
              user: widget.user!,
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeID, (route) => false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: kPagePadding.copyWith(),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: roomPagesButton(),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          elevation: 5,
                          isScrollControlled: true,
                          backgroundColor: backgroundColor,
                          builder: (context) {
                            return SearchRoomsView(
                              user: widget.user!,
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.search,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    allowImplicitScrolling: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: roomPages(),
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
