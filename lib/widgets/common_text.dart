import 'package:arham_b2c/app/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/app_font_weight.dart';

// ignore: must_be_immutable
class CommonText1 extends StatelessWidget {
  String text;
  FontWeight? fontWeight;
  double? fontSize;
  Color? color;
  Color? underlineColor;
  int? maxLine;
  TextDecoration? decorationUnderline;
  EdgeInsetsGeometry? padding;
  TextAlign? textAlign;
  bool? softWrap;
  TextOverflow? overflow;

  CommonText1({
    super.key,
    required this.text,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.maxLine,
    this.decorationUnderline,
    this.padding,
    this.textAlign,
    this.underlineColor,
    this.softWrap,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        maxLines: maxLine,
        textAlign: textAlign,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.visible,
        style: GoogleFonts.notoSans(
          fontSize: fontSize ?? AppDimensions.fontSizeRegular,
          fontWeight: fontWeight ?? AppFontWeight.medium,
          color: color,
        ),
      ),
    );
  }
}

class CommonText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final Color? underlineColor;
  final int? maxLine;
  final TextDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextStyle? style;
  final TextTheme? textTheme;

  const CommonText({
    super.key,
    required this.text,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.maxLine,
    this.decoration,
    this.padding,
    this.textAlign,
    this.underlineColor,
    this.softWrap,
    this.overflow,
    this.style,
    this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextTheme = textTheme ?? theme.textTheme;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        text,
        maxLines: maxLine,
        textAlign: textAlign,
        softWrap: softWrap ?? true,
        overflow: overflow ?? TextOverflow.visible,
        style: (style ?? effectiveTextTheme.bodyMedium)?.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
          decorationColor: underlineColor,
        ),
      ),
    );
  }
}
