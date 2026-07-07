import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';

class CommonDropdown extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool isEnabled;
  final String? initialValue;

  const CommonDropdown({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isEnabled = true,
    this.initialValue,
  });

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue =
        widget.initialValue?.isNotEmpty == true ? widget.initialValue : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // final textColor = widget.isEnabled
    //     ? colorScheme.onSurface
    //     : theme.disabledColor;

    final borderColor =
        widget.isEnabled ? colorScheme.primary : theme.disabledColor;

    return DropdownButtonFormField<String>(
      //value: widget.items.contains(widget.value) ? widget.value : null,
      initialValue: widget.items.contains(widget.value) ? widget.value : null,
      hint: CommonText(
        text: widget.hintText,
        //style: TextStyle(fontSize: 14, color: textColor),
      ),
      items:
          widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: CommonText(
                text: item /*style: TextStyle(color: textColor)*/,
              ),
            );
          }).toList(),
      onChanged: widget.isEnabled ? widget.onChanged : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        // labelStyle: TextStyle(
        //   color: widget.isEnabled ? colorScheme.onSurface : theme.disabledColor,
        // ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 4.0,
        ),
      ),
      icon: Icon(Icons.keyboard_arrow_down),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }
}
