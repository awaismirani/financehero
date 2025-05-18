import 'package:financehero/controllers/income_controller.dart';
import 'package:financehero/views/worthit/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SetYourGoalScreen extends StatefulWidget {
  const SetYourGoalScreen({super.key});

  @override
  State<SetYourGoalScreen> createState() => _SetYourGoalScreenState();
}

class _SetYourGoalScreenState extends State<SetYourGoalScreen> {
  final goalNameController = TextEditingController();
  final costController = TextEditingController();

  String goalType = "Experience";
  double memoryImpact = 10;
  int emotionalValue = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              SizedBox(height: 20.h),
              _buildTextField("Goal Name", goalNameController),

              SizedBox(height: 16.h),
              _buildTextField("Cost (\$)", costController, keyboardType: TextInputType.number),

              SizedBox(height: 24.h),
              Text("Type of Goal", style: _sectionTitleStyle()),
              SizedBox(height: 10.h),
              _buildGoalTypeToggle(),

              SizedBox(height: 24.h),
              _buildSliderRow(
                "How long will you remember this?",
                "${memoryImpact.toInt()} years",
              ),
              Slider(
                value: memoryImpact,
                min: 0,
                max: 20,
                divisions: 20,
                label: "${memoryImpact.toInt()}",
                onChanged: (val) => setState(() => memoryImpact = val),
                activeColor: Colors.green,
              ),

              SizedBox(height: 24.h),
              Text("How much will you love the experience", style: _sectionTitleStyle()),
              SizedBox(height: 12.h),
              _buildEmotionalScale(),

              SizedBox(height: 40.h),
              _buildCalculateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.flag_circle_outlined, size: 32.sp, color: Colors.deepPurple),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set Your Goal', style: GoogleFonts.poppins(fontSize: 20.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text(
                'Define what you want to save for and how much it means to you.',
                style: GoogleFonts.poppins(fontSize: 13.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  Widget _buildGoalTypeToggle() {
    return Row(
      children: ["Product", "Experience"].map((type) {
        final isSelected = goalType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => goalType = type),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                type,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSliderRow(String label, String valueText) {
    return Row(
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14.sp)),
        const Spacer(),
        Text(valueText, style: GoogleFonts.poppins(fontSize: 13.sp, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildEmotionalScale() {
    final labels = [
      "Like any other day",
      "Think of it fondly",
      "Enjoy it a lot",
      "Cherished memory",
      "Once in a lifetime",
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final isSelected = emotionalValue == index + 1;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => emotionalValue = index + 1),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  Text('${index + 1}',
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 4.h),
                  Text(labels[index],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: isSelected ? Colors.white : Colors.black,
                      )),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onCalculatePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        child: Text("Calculate", style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.bold,color: Colors.white)),
      ),
    );
  }

  void _onCalculatePressed() {
    final incomeCtrl = Get.find<IncomeController>();

    final double cost = double.tryParse(costController.text.trim()) ?? 0;
    final double hourly = incomeCtrl.hourly;
    final double timeToSaveHours = cost / (hourly == 0 ? 1 : hourly); // avoid division by zero
    final double days = timeToSaveHours / incomeCtrl.hoursPerDay.value;
    final double weeks = days / incomeCtrl.daysPerWeek.value;
    final double months = weeks / 4.33;
    final double years = months / 12;

    double score = ((memoryImpact * emotionalValue) / (years == 0 ? 1 : years)) * 10;
    if (goalType == "Product") score -= 5;
    score = score.clamp(0, 100);

    Get.to(() => ResultScreen(
          title: score > 70 ? "Worth it!" : score > 40 ? "Think Twice" : "Worthless",
          emoji: score > 70 ? "🔥" : score > 40 ? "🤔" : "😞",
          score: score.toInt(),
          goalName: goalNameController.text.trim(),
          type: goalType,
          cost: cost,
          days: days,
          weeks: weeks,
          months: months,
          years: years,
          memoryYears: memoryImpact.toInt(),
          loveScale: emotionalValue,
        ));
  }

  TextStyle _sectionTitleStyle() {
    return GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w500);
  }
}
