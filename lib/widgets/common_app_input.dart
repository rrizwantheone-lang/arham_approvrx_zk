import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app/app_colors.dart';

class CommonAppInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? isPassword;
  final double borderRadius;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final IconData? suffixIcon;
  final Widget? suffixWidget; // ✅ ADD THIS
  final IconData? prifixIcon;
  final Color? prifixColor;
  final Color? suffixColor;
  final VoidCallback? onSuffixClick;
  final VoidCallback? onPrifixClick;
  final TextInputAction textInputAction;
  final Function(String text)? onSubmitted;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String text)? onChanged;
  final Color borderColor;
  final Color? hintColor;
  final bool? isEnable;
  final bool isDateField;
  final EdgeInsets? padding;
  final EdgeInsets? prifixPadding;
  final int? maxLength;
  final int? maxLines; // No default here, user will pass it in or it will be 1
  final String? suFixImage;
  final String? prifixImage;
  final double? inputHeight;
  final double? inputWidth;
  final String? Function(String?)? validator;
  final TextCapitalization
  textCapitalization; // Add the textCapitalization property

  const CommonAppInput({
    super.key,
    required this.textEditingController,
    this.textInputType = TextInputType.text,
    this.textAlignVertical,
    this.textAlign,
    this.isPassword = false,
    this.borderRadius = 1,
    this.hintText = '',
    this.hintStyle,
    this.hintColor,
    this.labelStyle,
    this.suffixIcon,
    this.suffixWidget,
    this.prifixIcon,
    this.onSuffixClick,
    this.onPrifixClick,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.inputFormatters,
    this.onChanged,
    this.isEnable,
    this.isDateField = false,
    this.borderColor = AppColors.teal,
    this.padding,
    this.maxLength,
    this.maxLines = 1, // Default to 1 if not passed
    this.suFixImage,
    this.prifixImage,
    this.inputHeight,
    this.inputWidth,
    this.prifixPadding,
    this.prifixColor,
    this.suffixColor,
    this.validator,
    this.textCapitalization = TextCapitalization.none, // Default to none
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: inputHeight,
      width: inputWidth ?? double.infinity,
      child: TextFormField(
        textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
        onChanged: onChanged,
        textAlign: textAlign ?? TextAlign.start,
        focusNode: focusNode,
        controller: textEditingController,
        //cursorColor: AppColors.indigoSwatch,
        //keyboardType: textInputType,
        keyboardType: isDateField ? TextInputType.none : textInputType,
        obscureText: isPassword ?? false,
        textInputAction: textInputAction,
        onFieldSubmitted: (String text) {
          onSubmitted?.call(text);
          nextFocusNode?.requestFocus();
        },
        style: labelStyle,
        inputFormatters: inputFormatters,
        enabled: isEnable,
        maxLength: maxLength,
        maxLines: maxLines,
        // This is where maxLines is used
        readOnly: isDateField,
        onTap: isDateField ? onSuffixClick : null,
        validator: validator,
        textCapitalization: textCapitalization,
        // Set textCapitalization here
        decoration: InputDecoration(
          counter: const Offstage(),
          // suffixIconConstraints:
          // const BoxConstraints(minWidth: 16, minHeight: 39),
          // suffixIcon:
          //     suffixIcon != null
          //         ? Padding(
          //           padding: const EdgeInsets.only(right: 10),
          //           child: InkResponse(
          //             radius: 12,
          //             onTap: onSuffixClick,
          //             child: Icon(suffixIcon, size: 20, color: suffixColor),
          //           ),
          //         )
          //         : suFixImage != null
          //         ? Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: InkResponse(
          //             radius: 12,
          //             onTap: onSuffixClick,
          //             child: Image.asset(
          //               suFixImage!,
          //               height: 20,
          //               width: 20,
          //               color: suffixColor,
          //             ),
          //           ),
          //         )
          //         : null,

          suffixIcon: suffixWidget ??
              (suffixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkResponse(
                  radius: 12,
                  onTap: onSuffixClick,
                  child: Icon(
                    suffixIcon,
                    size: 20,
                    color: suffixColor,
                  ),
                ),
              )
                  : suFixImage != null
                  ? Padding(
                padding: const EdgeInsets.all(10),
                child: InkResponse(
                  radius: 12,
                  onTap: onSuffixClick,
                  child: Image.asset(
                    suFixImage!,
                    height: 20,
                    width: 20,
                    color: suffixColor,
                  ),
                ),
              )
                  : null),

          prefixIcon:
              prifixIcon != null
                  ? Padding(
                    padding: prifixPadding ?? const EdgeInsets.only(left: 10),
                    child: InkResponse(
                      radius: 15,
                      onTap: onPrifixClick,
                      child: Icon(prifixIcon, size: 20),
                    ),
                  )
                  : prifixImage != null
                  ? Padding(
                    padding: prifixPadding ?? const EdgeInsets.only(left: 10),
                    child: InkResponse(
                      radius: 15,
                      onTap: onPrifixClick,
                      child: Image.asset(
                        prifixImage!,
                        height: 20,
                        width: 20,
                        color: prifixColor,
                      ),
                    ),
                  )
                  : null,
          labelText: hintText,
          labelStyle: labelStyle ?? GoogleFonts.notoSans(fontSize: 14),
          hintStyle: hintStyle ?? GoogleFonts.notoSans(fontSize: 14),
          isDense: true,
          contentPadding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          // contentPadding: padding ??
          //     const EdgeInsets.symmetric(
          //       horizontal: 10,
          //       vertical: 10,
          //     ),

          //TODO : underline
          // enabledBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(
          //     //color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          //     color: Theme.of(context).colorScheme.primary,
          //     width: 1.0,
          //   ),
          // ),
          // focusedBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.primary,
          //     width: 1.0,
          //   ),
          // ),
          // disabledBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          //     width: 1.0,
          //   ),
          // ),

          //TODO : outline
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
