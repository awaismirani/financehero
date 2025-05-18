import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/goal_controller.dart';
import '../../models/goal_model.dart';

class EditGoalScreen extends StatefulWidget {
  final int index;
  const EditGoalScreen({super.key, required this.index});

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final goalController = Get.find<GoalController>();

  late TextEditingController nameController;
  late TextEditingController targetController;
  late TextEditingController savedController;
  late TextEditingController contributionController;

  String interval = 'Daily';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final goal = goalController.goals[widget.index];
    nameController = TextEditingController(text: goal.name);
    targetController = TextEditingController(text: goal.targetAmount.toString());
    savedController = TextEditingController(text: goal.savedAmount.toString());
    contributionController = TextEditingController(text: goal.contribution.toString());
    interval = goal.interval;
    selectedDate = DateFormat('dd/MM/yyyy').parse(goal.targetDate);
  }

  void saveChanges() async {
    final updatedGoal = GoalModel(
      name: nameController.text.trim(),
      targetAmount: double.tryParse(targetController.text) ?? 0,
      savedAmount: double.tryParse(savedController.text) ?? 0,
      interval: interval,
      contribution: double.tryParse(contributionController.text) ?? 0,
      targetDate: DateFormat('dd/MM/yyyy').format(selectedDate ?? DateTime.now()),
      emoji: goalController.goals[widget.index].emoji,
    );

    await goalController.updateGoal(widget.index, updatedGoal);
    Get.back(); // or Get.off to go back to details
  }

  void deleteGoal() async {
    await goalController.deleteGoal(widget.index);
    Get.back(); // remove edit screen
    Get.back(); // remove details screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text("EDIT GOAL", style: TextStyle(letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel", style: TextStyle(color: Colors.black)),
        ),
        actions: [
          TextButton(
            onPressed: saveChanges,
            child: Text("Save", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Goal name"),
            _textField(nameController),

            SizedBox(height: 20.h),
            _label("Goal target"),
            _textField(targetController, inputType: TextInputType.number),

            SizedBox(height: 20.h),
            _label("Saved amount"),
            _textField(savedController, inputType: TextInputType.number),

            SizedBox(height: 24.h),
            _label(""),

            Row(
              children: ['Daily', 'Weekly', 'Monthly'].map((tab) {
                final isSelected = interval == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => interval = tab),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tab.toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20.h),
            _label("${interval[0].toUpperCase()}${interval.substring(1)} amount"),
            _textField(contributionController, inputType: TextInputType.number),

            SizedBox(height: 24.h),
            Center(child: Text("Or", style: TextStyle(fontSize: 16.sp))),
            SizedBox(height: 20.h),

            _label("Target Date"),
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? now,
                  firstDate: now,
                  lastDate: DateTime(now.year + 50),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "Select date"
                          : DateFormat('dd.MM.yyyy').format(selectedDate!),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Icon(Icons.calendar_today_outlined, size: 20.sp),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30.h),
            Divider(),
            TextButton(
              onPressed: deleteGoal,
              child: Text(
                "Delete goal",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "This will remove all of your goal information and cannot be undone",
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _label(String title) {
    return Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600));
  }

  Widget _textField(TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
