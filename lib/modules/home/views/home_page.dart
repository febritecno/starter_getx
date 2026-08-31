import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/helpers.dart';
import 'package:myapp/helpers/third_party/sizer/sizer.dart';
import 'package:myapp/modules/home/models/news_model.dart';
import 'package:myapp/shared/theme.dart';
import 'package:myapp/shared/widgets/text_app.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyColor,
      appBar: AppBar(
        backgroundColor: kDarkBlueColor,
        automaticallyImplyLeading: false,
        title: TextApp('News',
            color: Colors.white, fontWeight: bold, fontSize: 18.sp),
        actions: [
          IconButton(
            onPressed: () => Helpers.clearToken(),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.news.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.news.isEmpty) {
          return Center(child: TextApp('No news', color: kDarkGreyColor));
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
                TextApp(n.title ?? '',
                    fontWeight: bold, fontSize: 15.sp, maxLines: 3),
                SizedBox(height: 6.h),
                TextApp(n.newsSite ?? '',
                    color: kBlueColor, fontSize: 11.sp, fontWeight: semiBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
