import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/goal_controller.dart';
import 'goal_summery_screen.dart';

class GoalSavingPlanScreen extends StatefulWidget {
  const GoalSavingPlanScreen({super.key});

  @override
  _GoalSavingPlanScreenState createState() => _GoalSavingPlanScreenState();
}

class _GoalSavingPlanScreenState extends State<GoalSavingPlanScreen> {
  final GoalController controller = Get.find();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  String selectedTab = 'WEEKLY';

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
          value: 0.75,
          minHeight: 4,
          backgroundColor: Colors.grey.shade300,
          color: Colors.green,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set a saving amount or a target completion date',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30.h),

            /// Toggle Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['DAILY', 'WEEKLY', 'MONTHLY'].map((tab) {
                final isSelected = selectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedTab = tab);
                      controller.interval.value = tab;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tab,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 24.h),

            /// Amount Input
            Text(
              '${selectedTab[0]}${selectedTab.substring(1).toLowerCase()} amount',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: '49.75৳',
                hintStyle: GoogleFonts.poppins(),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            SizedBox(height: 28.h),
            Center(
              child: Text(
                "Or",
                style: GoogleFonts.poppins(fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 28.h),

            /// Date Picker
            Text(
              'Target Date',
              style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 50),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                  controller.targetDate.value = DateFormat('dd/MM/yyyy').format(picked);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? DateFormat('dd.MM.yyyy').format(selectedDate!)
                          : 'Select Date',
                      style: GoogleFonts.poppins(fontSize: 16.sp),
                    ),
                    Icon(Icons.calendar_today, size: 18.sp),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),
            Row(
              children: [
                Icon(Icons.info_outline, size: 18.sp, color: Colors.grey),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'This is hypothetical and will not leave your bank account',
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// Continue Button
            ElevatedButton(
              onPressed: () {
                final amount = amountController.text.trim();
                if (amount.isEmpty && selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter an amount or select a date")),
                  );
                  return;
                }

                if (amount.isNotEmpty) {
                  controller.contribution.value = double.tryParse(amount) ?? 0.0;
                }

                Get.to(() => GoalSummaryScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                minimumSize: Size(double.infinity, 56.h),
              ),
              child: Text(
                "CONTINUE",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
