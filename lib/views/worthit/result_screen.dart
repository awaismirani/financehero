import 'package:financehero/views/worthit/income_screen.dart';
import 'package:financehero/views/worthit/set_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class ResultScreen extends StatelessWidget {
  final String emoji;
  final String title;
  final int score;
  final String goalName;
  final String type;
  final double cost;
  final double days;
  final double weeks;
  final double months;
  final double years;
  final int memoryYears;
  final int loveScale;

  const ResultScreen({
    super.key,
    required this.emoji,
    required this.title,
    required this.score,
    required this.goalName,
    required this.type,
    required this.cost,
    required this.days,
    required this.weeks,
    required this.months,
    required this.years,
    required this.memoryYears,
    required this.loveScale,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              // Emoji and Title
              Text(emoji, style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 12.h),
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: title == "Worthless"
                        ? Colors.red
                        : title == "Think Twice"
                            ? Colors.orange
                            : Colors.green),
              ),
              SizedBox(height: 6.h),
              Text(
                "This ${title == "Worthless" ? "doesn't" : "might"} seem like a good use of your money.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 13.sp),
              ),
              SizedBox(height: 20.h),

              // Goal Details Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goalName,
                        style: GoogleFonts.poppins(
                            fontSize: 18.sp, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4.h),
                    Text("$type • \$${cost.toStringAsFixed(0)}",
                        style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey)),
                    SizedBox(height: 12.h),

                    // Progress bar and score
                    Text("Goal Score", style: GoogleFonts.poppins(fontSize: 14.sp)),
                    SizedBox(height: 6.h),
                    LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: Colors.grey.shade300,
                      color: score > 70
                          ? Colors.green
                          : score > 40
                              ? Colors.orange
                              : Colors.red,
                    ),
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$score/100",
                        style: GoogleFonts.poppins(fontSize: 12.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Time breakdown
                    _timeRow("Time to save for this goal"),
                    _infoRow("Hours", "${(days * 24).toStringAsFixed(1)} h", "Days", "${days.toStringAsFixed(1)}"),
                    _infoRow("Weeks", "${weeks.toStringAsFixed(1)}", "Months", "${months.toStringAsFixed(1)}"),
                    _infoRow("Years", "${years.toStringAsFixed(1)}", "", ""),
                    SizedBox(height: 16.h),

                    // Impact breakdown
                    _timeRow("Estimated Impact"),
                    _infoRow("Years of use", "$memoryYears years", "Impact Level", "$loveScale/4"),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Calculate Another Goal"),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) =>  IncomeScreen()),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeRow(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(label,
          style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w600)),
    );
  }

  Widget _infoRow(String leftTitle, String leftValue, String rightTitle, String rightValue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leftTitle,
                    style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),
                Text(leftValue,
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (rightTitle.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(rightTitle,
                      style: GoogleFonts.poppins(fontSize: 12.sp, color: Colors.grey)),
                  Text(rightValue,
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ],
              ),
            )
        ],
      ),
    );
  }
}
