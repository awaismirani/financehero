import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSlider extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final void Function(double)? onChanged;

  const CustomSlider({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                )),
            const Spacer(),
            Text("${value.toInt()}",
                style: GoogleFonts.poppins(
                    fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: "${value.toInt()}",
          onChanged: onChanged,
          activeColor: Colors.green.shade600,
        ),
      ],
    );
  }
}
