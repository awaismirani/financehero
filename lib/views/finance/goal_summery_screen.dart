import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/goal_controller.dart';
import 'home_screen.dart';

class GoalSummaryScreen extends StatelessWidget {
  final controller = Get.find<GoalController>();

  final List<String> emojiOptions = [
    '📷', '🚗', '🏠', '💰', '🔨',
    '💳', '✈️', '🎄', '🤑', '📚',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: BackButton(),
        centerTitle: true,
        title: LinearProgressIndicator(
          value: 1.0,
          minHeight: 4,
          backgroundColor: Colors.grey.shade300,
          color: Colors.green,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your goal is looking great.',
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Choose a photo or emoji to display alongside your goal',
                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700]),
              ),
              SizedBox(height: 24.h),

              /// Summary Card
              Obx(() => _goalPreviewCard()),

              SizedBox(height: 30.h),

              /// Emoji Picker
              Text(
                'Pick a new emoji for your goal',
                style: GoogleFonts.poppins(fontSize: 14.sp),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: emojiOptions.map((emoji) {
                  return Obx(() {
                    final isSelected = emoji == controller.emoji.value;
                    return GestureDetector(
                      onTap: () => controller.emoji.value = emoji,
                      child: Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(emoji, style: TextStyle(fontSize: 26.sp)),
                      ),
                    );
                  });
                }).toList(),
              ),

              SizedBox(height: 30.h),

              /// Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    minimumSize: Size(double.infinity, 56.h),
                  ),
                  onPressed: () {
                    controller.saveGoal();
                    Get.offAll(() => DashboardScreen());
                  },
                  child: Text(
                    'CONTINUE',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalPreviewCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(controller.emoji.value, style: TextStyle(fontSize: 30.sp)),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.goalName.value,
                  style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  controller.targetDate.value,
                  style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: controller.progress,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.green,
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '৳${controller.savedAmount.value.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        '৳${controller.contribution.value.toStringAsFixed(2)} ${controller.interval.value}',
                        style: GoogleFonts.poppins(fontSize: 12.sp),
                      ),
                    ),
                    Text(
                      '৳${controller.targetAmount.value.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(fontSize: 14.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
