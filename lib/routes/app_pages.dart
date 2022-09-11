import 'package:absen/helpers/third_party/check_auth.dart';
import 'package:absen/modules/geotag/views/geotag_page.dart';
import 'package:absen/modules/home/views/dashboard_page.dart';
import 'package:get/get.dart';
import 'package:absen/routes/routes.dart';

import 'app_bindings.dart';

class AppPages {
  static const INITIAL = Routes.INITIAL;

  static final list = [
    GetPage(
        name: INITIAL,
        page: () {
          return CheckAuthScreen(
            loginScreen: GetPageRoute(
                routeName: Routes.GEOTAG,
                binding: DashboardBinding(),
                page: () => GeotagPage()),
            landingScreen: GetPageRoute(
              routeName: Routes.DASHBOARD,
              page: () => DashboardPage(),
              binding: DashboardBinding(),
            ),
          );
        }),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
  ];
}
