# GETX_CHEATSHEET.md

Fast reference for GetX as used in **this** boilerplate. Snippets follow the layer rules in
`CLAUDE.md` / `RULES.md` — copy them, don't invent new patterns. Upstream docs:
<https://github.com/jonataslaw/getx/tree/master/documentation/en_US> · <https://pub.dev/packages/get>

GetX gives you three things from one package: **state management**, **route management**, and
**dependency injection**. This repo uses all three.

---

## 1. State management (reactive `.obs` + `Obx`)

Make a variable observable with `.obs`, read/rebuild it with `Obx`. Wrap the **smallest** subtree.

```dart
// Controller
class HomeController extends GetxController {
  final isLoading = false.obs;      // RxBool
  final news = <NewsModel>[].obs;    // RxList
  final counter = 0.obs;            // RxInt

  void increment() => counter.value++;      // write via .value
  void setItems(List<NewsModel> l) => news.assignAll(l); // lists: assignAll, never reassign
}
```

```dart
// View — only the reactive part is inside Obx
Obx(() => controller.isLoading.value
    ? const CircleLoading()
    : Text('${controller.counter.value}', style: kTitle))
```

Rules that bite:
- Read/write value types via `.value` (`counter.value`, `isLoading.value`). Calling `isLoading(true)`
  is shorthand for `isLoading.value = true`.
- **Lists/maps: mutate with `.assignAll(...)` / `.add(...)`** — reassigning the Rx drops reactivity.
- `Obx` must actually *read* an `.obs` inside it, or it throws "improper use of GetX".
- Loading flag pattern — always reset in `finally`:

```dart
Future<void> fetchNews() async {
  try {
    isLoading(true);
    final res = await repository.getNews();
    if (res?.statusCode == 200) {
      news.assignAll((res!.data as List).map(NewsModel.fromJson).toList());
    }
  } catch (e) {
    AppSnackBar.error(e.toString());
  } finally {
    isLoading(false); // runs on success AND error
  }
}
```

### GetBuilder (non-reactive, manual)
For state that doesn't need per-value reactivity (e.g. tab index), this repo uses `GetBuilder` +
`update()` — cheaper, no `.obs`.

```dart
class DashboardController extends GetxController {
  int tabIndex = 0;
  void changeTabIndex(int i) { tabIndex = i; update(); } // update() rebuilds GetBuilder
}
```

```dart
GetBuilder<DashboardController>(
  init: DashboardController(),
  builder: (c) => /* uses c.tabIndex */,
)
```

`.obs`+`Obx` = fine-grained auto-rebuild. `GetBuilder`+`update()` = manual, lightweight. Pick one per
piece of state; don't mix for the same value.

---

## 2. Controller lifecycle

```dart
class MyController extends GetxController {
  final textCtrl = TextEditingController();

  @override
  void onInit() {          // called once when controller is created
    super.onInit();
    fetchData();           // auto-fetch belongs here — NEVER in build()
  }

  @override
  void onReady() => super.onReady();  // after first frame rendered

  @override
  void onClose() {         // dispose things you created
    textCtrl.dispose();
    super.onClose();
  }
}
```

---

## 3. Dependency injection

Register a dependency, then `Get.find()` it — never `new` a controller/repository in a view.

```dart
// register
Get.put(SomeService());                       // eager, kept alive
Get.put(ApiClient(Dio()), permanent: true);   // app-lifetime singleton (app_services.dart)
Get.lazyPut(() => AuthRepository(apiClient: Get.find())); // built on first find()
Get.lazyPut(() => HomeController(...), fenix: true);      // survives route pop, rebuilt if reused
await Get.putAsync(() => PrefsService().init());          // async init before use

// call
final repo = Get.find<AuthRepository>();      // retrieve anywhere
Get.isRegistered<HomeController>();            // check exists
Get.isPrepared<HomeController>();              // lazyPut not yet built

// delete / reset / replace / reload
Get.delete<HomeController>();                  // remove (respects fenix)
Get.delete<HomeController>(force: true);       // remove even if permanent/fenix
Get.reset();                                   // wipe ALL DI (tests / hard logout)
Get.replace<Api>(FakeApi());                   // swap instance (same type)
Get.lazyReplace(() => FakeApi());              // swap lazily
Get.reload<HomeController>();                  // dispose + rebuild from its factory
```

GetX auto-disposes non-`permanent`, non-`fenix` deps when their route pops — that's the memory win, so
prefer `lazyPut` in a binding and only reach for `fenix`/`permanent` when a dep must outlive its route.

### Binding that seeds args into a shared controller
```dart
class RecordBinding extends Bindings {
  @override
  void dependencies() =>
      Get.find<HomeController>().openRecord(Get.arguments as RecordModel?);
}
```

### Bindings (this repo's DI wiring)
Per-route deps live in `routes/app_bindings.dart` and attach in `app_pages.dart` — deps build only
when the route opens.

```dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(apiClient: Get.find()));
    Get.lazyPut(() => AuthController(repository: Get.find()));
  }
}
```

A `GetView<T>` auto-finds its controller — `controller` is `Get.find<T>()`:

```dart
class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) =>
      AppbarTemplate(title: 'Login', body: /* controller.onLogin(), controller.isLoading ... */);
}
```

---

## 4. Route management

Routes are `SCREAMING_SNAKE` consts in `routes/routes.dart`; register in `app_pages.dart`.

```dart
Get.toNamed(Routes.DASHBOARD);        // push named route
Get.offNamed(Routes.LOGIN);           // replace current
Get.offAllNamed(Routes.LOGIN);        // clear stack (used on logout / login success)
Get.back();                            // pop
Get.toNamed(Routes.DETAIL, arguments: item);   // pass data
final item = Get.arguments;                     // read on the other side
```

Add a screen in 3 steps (never skip one):
1. `routes/routes.dart` → `static const DETAIL = "/detail";`
2. `routes/app_bindings.dart` → `DetailBinding` (`lazyPut` repo + controller)
3. `routes/app_pages.dart` → `GetPage(name: Routes.DETAIL, page: () => DetailPage(), binding: DetailBinding())`

Navigate with `Routes.*` consts only — no raw path strings.

---

## 5. Snackbars / dialogs / bottom sheets

Use the app's system addons (`helpers/system/`), not `Get.snackbar` directly, so styling is uniform.

```dart
AppSnackBar.error('Something went wrong');
AppSnackBar.info('Saved');
AppDialog.show(...);
AppBottomSheet.show(...);
```

Raw GetX equivalents (what the addons wrap): `Get.snackbar(title, msg)`, `Get.dialog(widget)`,
`Get.bottomSheet(widget)`, `Get.defaultDialog(...)`. Prefer the `App*` wrappers.

---

## 6. Workers (react to an `.obs` changing)

Register in `onInit()`; they fire when an observable changes.

```dart
ever(count, (v) => print('changed to $v'));   // every change
once(count, (v) => print('first change only'));
debounce(query, search, time: Duration(milliseconds: 500)); // e.g. search-as-you-type
interval(count, (v) => log(v), time: Duration(seconds: 1)); // throttle
```

---

## 7. Utilities

```dart
Get.context           // BuildContext without passing it around
Get.width / Get.height
Get.isDarkMode
Get.find<T>()         // pull a registered dependency
GetUtils.isEmail(s)   // validators
```

---

## 8. Do / don't (matches RULES.md)

| Do | Don't |
|----|-------|
| `Get.find()` / bindings for deps | `AuthController()` by hand in a view |
| `.assignAll()` on RxList | reassign the RxList |
| reset loading flag in `finally` | reset only on success |
| smallest subtree in `Obx` | whole screen in one `Obx` |
| `onInit()` for auto-fetch | fetch in `build()` |
| `Routes.*` consts | raw `"/path"` strings |
| `Get.offAllNamed` on logout/login | manual `Navigator` stack juggling |
| `AppSnackBar.*` | raw `Get.snackbar` scattered per-screen |
