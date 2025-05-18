import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/goal_controller.dart';
import 'goal_saving_plan_screen.dart';

class GoalTargetScreen extends StatelessWidget {
  final controller = Get.find<GoalController>();
  final targetController = TextEditingController();
  final savedController = TextEditingController();

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
          value: 0.5,
          backgroundColor: Colors.grey.shade300,
          color: Colors.green,
          minHeight: 4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              'What is your target?',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 28.h),

            Text(
              'What is your goal target?',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: '30000৳',
                hintStyle: GoogleFonts.poppins(),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              'How much have you already saved? (if none that\'s ok!)',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: savedController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: '250৳',
                hintStyle: GoogleFonts.poppins(),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "We promise not to share this information with anybody unless you choose to",
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            ElevatedButton(
              onPressed: () {
                controller.targetAmount.value =
                    double.tryParse(targetController.text) ?? 0;
                controller.savedAmount.value =
                    double.tryParse(savedController.text) ?? 0;
                Get.to(() => GoalSavingPlanScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                minimumSize: Size(double.infinity, 56.h),
              ),
              child: Text("CONTINUE",
                  style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
