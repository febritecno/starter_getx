import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logistika/helpers/third_party/sizer/sizer.dart';

import '../../../shared/theme.dart';
import '../../../shared/widgets/components/main_header.dart';
import '../controllers/dashboard_controller.dart';
import 'home_page.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (_) => DefaultTabController(
              initialIndex: _.tabIndex.toInt(),
              length: 5,
              child: SafeArea(
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize:
                        Size.fromHeight(_.isHideHeader == false ? 16.w : 27.w),
                    child: MainHeader(
                      isVisible: _.isHideHeader,
                      tabBar: TabBar(
                        onTap: (index) => {controller.changeTabIndex(index)},
                        padding: EdgeInsets.all(2.w),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: kBlueColor,
                        unselectedLabelColor: Colors.grey.withOpacity(0.8),
                        labelColor: kBlueColor,
                        tabs: const [
                          Tab(icon: Icon(Icons.home, size: 30)),
                          Tab(icon: Icon(Icons.group, size: 30)),
                          Tab(icon: Icon(Icons.menu_book_rounded, size: 30)),
                          Tab(icon: Icon(Icons.person, size: 30)),
                          Tab(icon: Icon(Icons.menu, size: 30)),
                        ],
                      ),
                    ),
                  ),
                  body: Material(
                    color: Colors.white,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        HomePage(),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
