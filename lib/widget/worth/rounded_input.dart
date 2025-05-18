import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedInput extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? prefixText;
  final void Function(String)? onChanged;

  const RoundedInput({
    super.key,
    required this.label,
    this.initialValue,
    this.prefixText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            )),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: initialValue,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixText: prefixText ?? '',
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}
