import 'package:myapp/helpers/third_party/check_auth.dart';
import 'package:myapp/modules/auth/views/login_page.dart';
import 'package:myapp/modules/home/views/dashboard_page.dart';
import 'package:get/get.dart';
import 'package:myapp/routes/routes.dart';

import 'app_bindings.dart';

class AppPages {
  static const INITIAL = Routes.INITIAL;

  static const SIGN_UP = "${Routes.LOGIN}${Routes.SIGN_UP}";
  static const FORGOT_PASSWORD = "${Routes.LOGIN}${Routes.FORGOT_PASSWORD}";

  static final list = [
    GetPage(
        name: INITIAL,
        page: () {
          return CheckAuthScreen(
            loginScreen: GetPageRoute(
                routeName: Routes.LOGIN,
                page: () => LoginPage(),
                binding: AuthBinding()),
            landingScreen: GetPageRoute(
              routeName: Routes.DASHBOARD,
              page: () => DashboardPage(),
              bindings: [
                DashboardBinding(),
                HomeBinding(),
              ],
            ),
          );
        }),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      bindings: [
        DashboardBinding(),
        HomeBinding(),
      ],
    ),
  ];
}
