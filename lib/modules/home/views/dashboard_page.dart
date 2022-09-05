import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logistika/helpers/third_party/animation_indexed.dart';
import 'package:logistika/modules/home/controllers/dashboard_controller.dart';
import 'package:logistika/modules/home/views/home_page.dart';
import 'package:logistika/shared/theme.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (controller) => SafeArea(
              child: Scaffold(
                body: Material(
                  child: AnimatedIndexedStack(
                      index: controller.tabIndex,
                      children: [
                        HomePage(),
                      ]),
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 0,
                          blurRadius: 2),
                    ],
                  ),
                  child: Visibility(
                    visible: false,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
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
                        selectedLabelStyle: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: TextStyle(fontSize: 12),
                        unselectedFontSize: 12,
                        onTap: controller.changeTabIndex,
                        items: [
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
            ));
  }
}
