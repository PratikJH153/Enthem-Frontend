import '/logic/provider/user_provider.dart';
import '/helper/error_constants.dart';
import '/widgets/primary_button.dart';
import '/logic/provider/global_data_provider.dart';
import '/database/repositories/room_api_repository.dart';
import '/models/room.dart';
import '/models/user.dart';
import '/screens/home/find_friends_screen.dart';
import 'group_chat_screen.dart';
import '/screens/home/messages_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/services/debug_console.dart';
import '/widgets/bottom_nav_button.dart';
import '/widgets/custom_snackbar.dart';
import '/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeID = "/homepage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String filename = "home_screen.dart";
  final RoomAPIRepository _roomApiRepository = RoomAPIRepository();
  late final PageController _pageController;
  FocusNode myfocus = FocusNode();
  int _bottomSelectedIndex = 1;
  bool _isLoading = false;
  final TextEditingController _roomController = TextEditingController();

  Future<void> addRoom(UserModel user) async {
    if (_roomController.text.trim().length > 5) {
      try {
        final Room room = Room(
          title: _roomController.text.trim(),
          ownerID: user.id!,
          coordinates: [
            user.longitude!,
            user.latitude!,
          ],
          createdAt: DateTime.now(),
        );
        await _roomApiRepository.addRoom(room);
        if (context.mounted) {
          await GlobalDataProvider.resetRoomsDataProvider(context);
        }

        if (context.mounted) {
          myfocus.unfocus();
          showSnackBar(
            context: context,
            status: "success",
            title: "Room created!",
            des: "Enjoy your presence",
          );
          _roomController.clear();
        }
      } catch (err) {
        debugError(err.toString(), filename);
        errorSnackBar(
          context: context,
          error: ErrorState.serverError,
        );
      }
    } else {
      if (context.mounted) {
        errorSnackBar(
          context: context,
          error: ErrorState.createRoomTitleRequired,
        );
      }
    }
  }

  List<Widget> buildBottomNavBarItems() {
    return [
      BottomNavButton(
        unselectedIcon: CupertinoIcons.compass,
        selectedIcon: CupertinoIcons.compass_fill,
        isSelected: _bottomSelectedIndex == 0,
        onTap: () {
          setState(() {
            _bottomSelectedIndex = 0;
            bottomTapped(0);
          });
        },
      ),
      BottomNavButton(
        unselectedIcon: CupertinoIcons.bolt_horizontal,
        selectedIcon: CupertinoIcons.bolt_horizontal_fill,
        isSelected: _bottomSelectedIndex == 1,
        onTap: () {
          setState(() {
            _bottomSelectedIndex = 1;
            bottomTapped(1);
          });
        },
      ),
      BottomNavButton(
        unselectedIcon: CupertinoIcons.paperplane,
        selectedIcon: CupertinoIcons.paperplane_fill,
        isSelected: _bottomSelectedIndex == 2,
        onTap: () {
          setState(() {
            _bottomSelectedIndex = 2;
            bottomTapped(2);
          });
        },
      ),
      BottomNavButton(
        unselectedIcon: CupertinoIcons.person,
        selectedIcon: CupertinoIcons.person_fill,
        isSelected: _bottomSelectedIndex == 3,
        onTap: () {
          setState(() {
            _bottomSelectedIndex = 3;
            bottomTapped(3);
          });
        },
      ),
    ];
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 1,
      keepPage: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    _roomController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void bottomTapped(int index) {
    setState(() {
      _bottomSelectedIndex = index;
      _pageController.jumpToPage(
        index,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    UserDataProvider provider = context.watch<UserDataProvider>();
    final UserModel? user = provider.userData;

    if (provider.userDataAsyncState == AsyncState.isLoading || _isLoading) {
      return const LoadingWidget();
    }

    if (provider.userDataAsyncState == AsyncState.wentWrong) {
      return const WentWrongPage();
    }

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            color: Color.fromARGB(255, 36, 35, 35),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _bottomSelectedIndex == 1
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.black38,
                            ),
                            child: TextField(
                              focusNode: myfocus,
                              controller: _roomController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: "Create a room...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        PrimaryButton(
                          icon: CupertinoIcons.paperplane,
                          onTap: () async {
                            await addRoom(user!);
                            if (context.mounted) {
                              await GlobalDataProvider.resetRoomsDataProvider(
                                  context);
                            }
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buildBottomNavBarItems(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        allowImplicitScrolling: false,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          FindFriendsPage(),
          GroupChatPage(),
          MessagesPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
