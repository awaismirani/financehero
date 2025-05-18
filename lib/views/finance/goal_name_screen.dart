import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/goal_controller.dart';
import 'goal_target_screen.dart';

class GoalNameScreen extends StatelessWidget {
  final goalController = Get.put(GoalController());
  final TextEditingController textController = TextEditingController();

  final List<String> categories = [
    '🚗 New Car',
    '🏠 House Deposit',
    '✈️ Dream Holiday',
    '🔨 Home Renovation',
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
          value: 0.25,
          backgroundColor: Colors.grey.shade300,
          color: Colors.green,
          minHeight: 4,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'What are you aspiring for?',
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Name your goal',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: textController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                hintText: 'Goal Name',
                hintStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Or choose one of our most popular goals',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: categories.map((cat) {
                return GestureDetector(
                  onTap: () {
                    textController.text = cat;
                    goalController.goalName.value = cat;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  minimumSize: Size(double.infinity, 56.h),
                ),
                onPressed: () {
                  final name = textController.text.trim();
                  if (name.isEmpty) return;
                  goalController.goalName.value = name;
                  Get.to(() => GoalTargetScreen());
                },
                child: Text("CONTINUE",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
