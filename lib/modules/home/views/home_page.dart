import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/helpers.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/modules/home/models/news_model.dart';
import 'package:myapp/shared/theme.dart';
import 'package:myapp/shared/widgets/templates/appbar_template.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // AppbarTemplate is the single screen foundation: status bar + SafeArea +
    // app bar all handled here. Root tab → no back button.
    return AppbarTemplate(
      title: 'News',
      showBack: false,
      isCenter: false,
      isCustom: true,
      backgroundColor: kGreyColor,
      actions: [
        IconButton(
          onPressed: () => Helpers.clearToken(),
          icon: const Icon(Icons.logout, color: kDarkBlueColor),
        ),
      ],
      body: Obx(() {
        if (controller.isLoading.value && controller.news.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.news.isEmpty) {
          return Center(
              child: Text('No news',
                  style: kBody.copyWith(color: kDarkGreyColor)));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchNews,
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: controller.news.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, i) => _newsCard(controller.news[i]),
          ),
        );
      }),
    );
  }

  Widget _newsCard(NewsModel n) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (n.imageUrl != null && n.imageUrl!.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                n.imageUrl!,
                fit: BoxFit.cover,
                cacheWidth: 800, // decode downscaled — saves memory
                errorBuilder: (_, __, ___) => Container(color: kGreyColor),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(color: kLightGreyColor),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.title ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: kTitle.copyWith(fontSize: 15.sp)),
                SizedBox(height: 6.h),
                Text(n.newsSite ?? '',
                    style: kBodySm.copyWith(
                        color: kBlueColor,
                        fontSize: 11.sp,
                        fontWeight: semiBold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
