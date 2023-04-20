import 'package:enthem2frontend/constants/page_padding.dart';
import 'package:enthem2frontend/models/room.dart';
import 'package:enthem2frontend/models/user.dart';
import 'package:enthem2frontend/screens/room/near_rooms.dart';
import 'package:enthem2frontend/screens/room/world_rooms.dart';
import 'package:enthem2frontend/theme/theme.dart';
import 'package:enthem2frontend/widgets/custom_dialog_box.dart';
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
              onTap: () => showCustomDialog(context),
            ),
          ];
  }

  List<Widget> roomPages() {
    return widget.user!.isLocationGiven
        ? [
            NearRoomsPage(
              user: widget.user,
            ),
            const WorldRoomsPage()
          ]
        : [
            const WorldRoomsPage(),
            NearRoomsPage(
              user: widget.user,
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: kPagePadding.copyWith(),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text(
              //       "Explore interests",
              //       style: TextStyle(
              //         fontSize: 15,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         "See All  >",
              //         style: TextStyle(
              //           fontSize: 15,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 36,
              //   child: ListView.builder(
              //     itemCount: exploreInterests.length,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       final interest = exploreInterests[index];
              //       return Container(
              //         margin: const EdgeInsets.only(
              //           right: 8,
              //         ),
              //         child: ElevatedButton.icon(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.white,
              //           ),
              //           onPressed: () {},
              //           icon: Icon(
              //             interest.iconData,
              //             color: interest.color,
              //             size: 20,
              //           ),
              //           label: Text(
              //             interest.title,
              //             style: const TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.bold,
              //               fontSize: 13,
              //             ),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: ExploreInterestWidget(
              //         iconData: Icons.celebration,
              //         title: "New",
              //         isSelected: true,
              //         color: Colors.amber,
              //         onTap: () {},
              //       ),
              //     ),
              //     Expanded(
              //       child: ExploreInterestWidget(
              //         iconData: CupertinoIcons.flame_fill,
              //         title: "Hot",
              //         isSelected: false,
              //         color: Colors.orange,
              //         onTap: () {},
              //       ),
              //     ),
              //     Expanded(
              //       child: ExploreInterestWidget(
              //         iconData: CupertinoIcons.globe,
              //         title: "World",
              //         isSelected: false,
              //         color: Colors.blue,
              //         onTap: () {},
              //       ),
              //     ),
              //   ],
              // ),
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
                    onPressed: () {},
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
    );
  }
}
