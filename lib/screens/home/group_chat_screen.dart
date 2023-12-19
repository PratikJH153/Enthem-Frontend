import '/logic/provider/user_provider.dart';
import '/constants/page_padding.dart';
import '/models/room.dart';
import '/models/user.dart';
import '/screens/home/home_screen.dart';
import '/screens/room/near_rooms.dart';
import '/screens/room/world_rooms.dart';
import '/theme/theme.dart';
import '/views/search_rooms_view.dart';
import '/widgets/custom_dialog_box.dart';
import '/widgets/dialog_box_widget.dart';
import '/widgets/explore_interest_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupChatPage extends StatefulWidget {
  static const routeID = "/groupchatpage";

  const GroupChatPage({super.key});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
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
    UserDataProvider userDataProvider = context.read<UserDataProvider>();
    UserModel user = userDataProvider.userData!;

    return user.isLocationGiven
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
    UserDataProvider userDataProvider = context.read<UserDataProvider>();
    UserModel user = userDataProvider.userData!;

    return user.isLocationGiven
        ? const [NearRoomsPage(), WorldRoomsPage()]
        : const [WorldRoomsPage(), NearRoomsPage()];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool pop) async {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeID, (route) => false);
        return;
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
                            return const SearchRoomsView();
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
