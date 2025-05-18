import 'package:financehero/controllers/goal_controller.dart';
import 'package:financehero/models/goal_model.dart';
import 'package:financehero/views/finance/goal_details_screen.dart';
import 'package:financehero/views/worthit/income_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'goal_name_screen.dart';

class DashboardScreen extends StatelessWidget {
  final goalController = Get.find<GoalController>();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final goals = goalController.goals;
        final totalSaved = goals.fold(0.0, (sum, g) => sum + g.savedAmount);
        final totalTarget = goals.fold(0.0, (sum, g) => sum + g.targetAmount);
        final totalProgress = totalTarget == 0 ? 0.0 : totalSaved / totalTarget;

        return Column(
          children: [
            SizedBox(height: 50.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Column(
                children: [
                  // 🧠 Track Goals Neumorphic Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -3),
                          blurRadius: 6,
                        ),
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.track_changes,
                            color: Colors.deepPurple, size: 28.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Track goals with FinanceHero",
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // 📊 Worth It? Navigation Section
                  GestureDetector(
                    onTap: () {
                      // Navigate to Worth It feature
                      Get.to(() =>
                          IncomeScreen()); // replace with your actual screen
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.bar_chart_rounded,
                              color: Colors.white, size: 24.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Worth It?",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 16.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Active title
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 20.h, 20.w, 6.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Active",
                    style: GoogleFonts.poppins(
                        fontSize: 18.sp, fontWeight: FontWeight.w600)),
              ),
            ),

            /// Goal list or empty animation
            Expanded(
              child: goals.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/goals.json', height: 160.h),
                        SizedBox(height: 16.h),
                        Text("No goals added yet",
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp, color: Colors.grey)),
                      ],
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemCount: goals.length,
                      itemBuilder: (_, index) {
                        final g = goals[index];
                        return AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 300 + index * 100),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: _goalCard(g, index),
                          ),
                        );
                      },
                    ),
            ),

            /// Add more goals title
            if (goals.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Add more goals",
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                ),
              ),

            /// Summary
            if (goals.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: totalProgress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.green,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("৳${totalSaved.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins()),
                        Text(
                          "Saved ${(totalProgress * 100).toStringAsFixed(2)}%",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        Text("৳${totalTarget.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins()),
                      ],
                    ),
                  ],
                ),
              ),

            /// Add New Goal Button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  minimumSize: Size(double.infinity, 46.h),
                ),
                onPressed: () {
                  goalController.reset();
                  Get.to(() => GoalNameScreen());
                },
                child: Text("ADD NEW GOAL",
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp, color: Colors.white)),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _goalCard(GoalModel goal, int index) {
    return GestureDetector(
      onTap: () => Get.to(() => GoalDetailScreen(index: index)),
      child: Container(
        padding: EdgeInsets.all(16.w),
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
              child: Text(goal.emoji, style: TextStyle(fontSize: 30.sp)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        goal.name,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(goal.progress * 100).toStringAsFixed(2)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 12.sp),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    goal.targetDate,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: goal.progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.green,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '৳${goal.savedAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(fontSize: 14.sp),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          '৳${goal.contribution.toStringAsFixed(2)} ${goal.interval}',
                          style: GoogleFonts.poppins(fontSize: 12.sp),
                        ),
                      ),
                      Text(
                        '৳${goal.targetAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
