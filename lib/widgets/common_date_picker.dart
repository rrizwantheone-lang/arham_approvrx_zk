import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonDatePickerInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final String hintText;
  final FocusNode? focusNode;
  final IconData? suffixIcon;
  final Function()? onTap; // Trigger date picker
  final TextStyle? textStyle;
  final Color? enabledBorderColor;
  final Color? disabledBorderColor;

  const CommonDatePickerInput({
    Key? key,
    required this.controller,
    required this.isEnabled,
    required this.hintText,
    this.focusNode,
    this.suffixIcon = Icons.calendar_month,
    this.onTap,
    this.textStyle,
    this.enabledBorderColor,
    this.disabledBorderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: true,
          enabled: isEnabled,
          style: textStyle ?? GoogleFonts.notoSans(fontSize: 14),
          decoration: InputDecoration(
            labelText: hintText,
            labelStyle: GoogleFonts.notoSans(fontSize: 14),
            suffixIcon: Icon(
              suffixIcon,
              size: 20,
              color:
                  isEnabled
                      ? (enabledBorderColor ?? theme.primaryColor)
                      : (disabledBorderColor ?? theme.disabledColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: enabledBorderColor ?? theme.primaryColor,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: disabledBorderColor ?? theme.disabledColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(
                color: enabledBorderColor ?? theme.primaryColor,
                width: 1,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
        ),
      ),
    );
  }
}
