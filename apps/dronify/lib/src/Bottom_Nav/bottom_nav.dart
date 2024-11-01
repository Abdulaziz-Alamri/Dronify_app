import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dronify/Data_layer/data_layer.dart';
import 'package:dronify/src/Bottom_Nav/bottom_nav_bloc/bottom_nav_bloc.dart';
import 'package:dronify/src/live_chat/live_chat.dart';
import 'package:dronify/utils/db_operations.dart';
import 'package:dronify/utils/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatelessWidget {
  final int index;
  const BottomNav({super.key, this.index=0});

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconList = [
      FontAwesomeIcons.house,
      FontAwesomeIcons.cartShopping,
      FontAwesomeIcons.solidUser,
    ];

    return BlocProvider(
      create: (context) => BottomNavBloc()..add(LoadEvent(index: index)),
      child: Builder(builder: (context) {
        return Scaffold(
          extendBody: true,
          body: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<BottomNavBloc>(context);
              int currentPageIndex = bloc.currentIndex;

              if (state is SuccessChangeViewState) {
                currentPageIndex = state.currentPageIndex;
              }

              return IndexedStack(
                index: currentPageIndex,
                children: bloc.views,
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              print('${locator.get<DataLayer>().cart.items}');
              // String chatId = await checkChat(
              //     chatId: Random().nextInt(999999999).toString());

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ChatScreen(
              //             chatId: chatId,
              //           )),
              // );
            },
            backgroundColor: Colors.black,
            child: const Icon(Icons.message, size: 25, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: BlocBuilder<BottomNavBloc, BottomNavState>(
            builder: (context, state) {
              final bloc = BlocProvider.of<BottomNavBloc>(context);
              int currentPageIndex = bloc.currentIndex;

              if (state is SuccessChangeViewState) {
                currentPageIndex = state.currentPageIndex;
              }
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: AnimatedBottomNavigationBar.builder(
                  itemCount: iconList.length,
                  tabBuilder: (int index, bool isActive) {
                    final color = isActive ? Colors.blue : Colors.white;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Icon(
                            iconList[index],
                            size: 23,
                            color: color,
                          ),
                        ),
                        if (isActive)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            height: 5,
                            width: 20,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                      ],
                    );
                  },
                  backgroundColor: Colors.transparent,
                  height: 50,
                  activeIndex: currentPageIndex,
                  gapLocation: GapLocation.end,
                  gapWidth: 40,
                  leftCornerRadius: 30,
                  rightCornerRadius: 0,
                  splashRadius: 30,
                  notchSmoothness: NotchSmoothness.softEdge,
                  onTap: (index) {
                    BlocProvider.of<BottomNavBloc>(context)
                        .add(ChangeEvent(index: index));
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
