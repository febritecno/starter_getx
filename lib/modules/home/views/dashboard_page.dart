import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:myapp/helpers/third_party/animation_indexed.dart';
import 'package:myapp/modules/home/controllers/dashboard_controller.dart';
import 'package:myapp/modules/home/views/home_page.dart';
import 'package:myapp/shared/theme.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Shell scaffold: owns the bottom nav + tab switching. Each tab page
    // (HomePage) is an AppbarTemplate, so app bar + SafeArea live there.
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (controller) => Scaffold(
        body: Material(
          child:
              AnimatedIndexedStack(index: controller.tabIndex, children: const [
            HomePage(),
          ]),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 2),
            ],
          ),
          child: Visibility(
            visible: false,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                currentIndex: controller.tabIndex,
                selectedItemColor: kBlueColor,
                unselectedItemColor: Colors.black87,
                selectedFontSize: 12,
                selectedLabelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
                unselectedFontSize: 12,
                onTap: controller.changeTabIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.abc_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.abc_rounded),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
