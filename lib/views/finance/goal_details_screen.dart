// goal_detail_screen.dart
import 'package:financehero/views/finance/edit_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/goal_controller.dart';
import '../../widget/finance/update_amount_model.dart';

class GoalDetailScreen extends StatelessWidget {
  final int index;
  final goalController = Get.find<GoalController>();

  GoalDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final goal = goalController.goals[index];

      return Scaffold(
        appBar: AppBar(
          title: Text(goal.name),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Get.to(() => EditGoalScreen(index: index));
              },
            ),
          ],
        ),

        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Text(
                    'You have saved ${(goal.progress * 100).toStringAsFixed(2)}% of your goal,\nGreat work!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  LinearProgressIndicator(
                    value: goal.progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard('৳${goal.savedAmount.toStringAsFixed(2)}', 'Today'),
                      _statCard('৳${goal.contribution.toStringAsFixed(2)}', goal.interval),
                      _statCard('৳${goal.targetAmount.toStringAsFixed(2)}', goal.targetDate),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  minimumSize: Size(double.infinity, 50.h),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
                    builder: (_) => UpdateAmountModal(index: index),
                  );
                },
                child: Text('UPDATE AMOUNT', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _statCard(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
      ],
    );
  }
}
