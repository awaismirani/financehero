// update_amount_modal.dart
import 'package:financehero/controllers/goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateAmountModal extends StatefulWidget {
  final int index;
  const UpdateAmountModal({super.key, required this.index});

  @override
  State<UpdateAmountModal> createState() => _UpdateAmountModalState();
}

class _UpdateAmountModalState extends State<UpdateAmountModal> {
  final goalController = Get.find<GoalController>();
  late double updatedAmount;

  @override
  void initState() {
    super.initState();
    updatedAmount = goalController.goals[widget.index].savedAmount;
  }

  void _add(double amount) {
    setState(() {
      updatedAmount += amount;
    });
  }

  Future<void> _save() async {
    await goalController.updateSavedAmount(widget.index, updatedAmount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 40.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Update Amount', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: '৳${updatedAmount.toStringAsFixed(2)}'),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'How much have you saved?',
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _quickAddButton(10),
              _quickAddButton(20),
              _quickAddButton(100),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'This is hypothetical and will not leave your bank account',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              minimumSize: Size(double.infinity, 48.h),
            ),
            child: Text('SAVE GOAL', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _quickAddButton(double amount) {
    return ElevatedButton(
      onPressed: () => _add(amount),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text('+ ৳$amount', style: TextStyle(fontSize: 14.sp)),
    );
  }
}
