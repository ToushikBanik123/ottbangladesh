import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../tv/live_tv.dart';
import 'home_container_controller.dart';

class HomeContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal.copyWith(
        systemNavigationBarColor: colorBottomBarBackground,
      ),
      child: Scaffold(
        backgroundColor: colorPageBackground,
        extendBodyBehindAppBar: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GetBuilder<HomeContainerController>(
          id: "fab",
          init: HomeContainerController(),
          builder: (viewController) {
            return GestureDetector(
              onTap: () {
                viewController.changeBottomBarIndex(2);
              },
              child: Image.asset(
                "images/ic_live_tv.png",
                fit: BoxFit.fitHeight,
                height: 0.0,
                color: viewController.selectedBottomBarIndex == 2
                    ? colorHighlight
                    : colorDisabled,
              ),
            );
          },
        ),
        body: LiveTvPage(),
        // bottomNavigationBar: buildBottomBar(),
        // body: GetBuilder<HomeContainerController>(
        //   id: 'body',
        //   init: HomeContainerController(),
        //   builder: (controller) {
        //     return controller.body.marginOnly(bottom: 0.0);
        //   },
        // ),
      ),
    );
  }

  Widget buildBottomBar() {
    return GetBuilder<HomeContainerController>(
      id: 'bottom_bar',
      init: HomeContainerController(),
      builder: (HomeContainerController viewController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
          ),
          child: BottomNavigationBar(
            elevation: 0.0,
            backgroundColor: colorBottomBarBackground,
            currentIndex: viewController.selectedBottomBarIndex,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle: textStyleBottomBarItem,
            unselectedLabelStyle: textStyleBottomBarItem,
            selectedItemColor: colorHighlight,
            unselectedItemColor: colorDisabled,
            items: [
              getBottomBarItem(
                viewController,
                'images/ic_fs.png',
                "Fs",
                0,
              ),
              getBottomBarItem(
                viewController,
                'images/ic_videos.png',
                "Videos",
                1,
              ),
              getBottomBarItem(
                viewController,
                '',
                "Live TV",
                2,
              ),
              getBottomBarItem(
                viewController,
                'images/ic_update.png',
                "Update",
                3,
              ),
              getBottomBarItem(
                viewController,
                'images/ic_more.png',
                'More',
                4,
              ),
            ],
            onTap: (index) {
              viewController.changeBottomBarIndex(index);
            },
          ),
        );
      },
    );
  }

  BottomNavigationBarItem getBottomBarItem(
    HomeContainerController viewController,
    String imagePath,
    String title,
    int position,
  ) {
    return BottomNavigationBarItem(
      icon: imagePath.trim().isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: 0.0,
              ),
              child: (position == viewController.selectedBottomBarIndex
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.fitHeight,
                      height: 32.0,
                      color: colorHighlight,
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.fitHeight,
                      height: 32.0,
                      color: colorDisabled,
                    )),
            )
          : SizedBox(height: 32.0),
      label: title,
    );
  }
}
