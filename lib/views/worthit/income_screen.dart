import 'package:financehero/controllers/income_controller.dart';
import 'package:financehero/views/worthit/set_goal_screen.dart';
import 'package:financehero/widget/worth/custom_slider.dart';
import 'package:financehero/widget/worth/header_title.dart';
import 'package:financehero/widget/worth/rounded_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class IncomeScreen extends StatelessWidget {
  final controller = Get.put(IncomeController());

  IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: const BackButton(),
        centerTitle: true,
        title: LinearProgressIndicator(
          value: 0.55,
          backgroundColor: Colors.grey.shade300,
          color: Colors.green,
          minHeight: 4,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Obx(() {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(title: 'Worth It?'),
                  SizedBox(height: 4.h),
                  Text(
                    'Determine if that purchase is really worth your hard-earned money',
                    style: GoogleFonts.poppins(fontSize: 13.sp),
                  ),
                  SizedBox(height: 24.h),

                  Text("Income Details", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  SizedBox(height: 4.h),
                  Text(
                    "Enter your income details to calculate how much you save over time.",
                    style: GoogleFonts.poppins(fontSize: 13.sp),
                  ),
                  SizedBox(height: 20.h),

                  // Monthly Income Input
                  RoundedInput(
                    label: "Monthly Income",
                    prefixText: controller.currency.value,
                    initialValue: controller.income.value.toStringAsFixed(2),
                    onChanged: (val) =>
                        controller.income.value = double.tryParse(val) ?? 0.0,
                  ),
                  SizedBox(height: 16.h),

                  // Sliders
                  CustomSlider(
                    title: "Savings Percentage",
                    min: 0,
                    max: 100,
                    value: controller.percentage.value,
                    onChanged: (val) => controller.percentage.value = val,
                  ),
                  CustomSlider(
                    title: "Hours/Day",
                    min: 1,
                    max: 24,
                    value: controller.hoursPerDay.value,
                    onChanged: (val) => controller.hoursPerDay.value = val,
                  ),
                  CustomSlider(
                    title: "Days/Week",
                    min: 1,
                    max: 7,
                    value: controller.daysPerWeek.value,
                    onChanged: (val) => controller.daysPerWeek.value = val,
                  ),

                  SizedBox(height: 20.h),

                  // Result Box
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ResultTile(label: "Yearly", value: controller.yearly, symbol: controller.currency.value),
                        _ResultTile(label: "Monthly", value: controller.monthly, symbol: controller.currency.value),
                        _ResultTile(label: "Weekly", value: controller.weekly, symbol: controller.currency.value),
                        _ResultTile(label: "Daily", value: controller.daily, symbol: controller.currency.value),
                        _ResultTile(label: "Hourly", value: controller.hourly, symbol: controller.currency.value),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        controller.saveData(); // Persist if needed
                        Get.to(() => const SetYourGoalScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      label: Text("Next",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}




class _ResultTile extends StatelessWidget {
  final String label;
  final double value;
  final String symbol;

  const _ResultTile({
    required this.label,
    required this.value,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.black54,
              )),
          Text('$symbol ${value.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                  fontSize: 14.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
