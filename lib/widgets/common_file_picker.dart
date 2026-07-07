import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:path/path.dart' as p;

class CommonFilePicker extends StatelessWidget {
  final String hintText;
  final File? selectedFilePath;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const CommonFilePicker({
    super.key,
    required this.hintText,
    required this.selectedFilePath,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    String fileName =
        selectedFilePath != null
            ? p.basename(selectedFilePath!.path)
            : hintText;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CommonText(
                text: fileName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.attach_file, size: 20),
                if (selectedFilePath != null)
                  InkWell(
                    onTap: onClear,
                    child: const Icon(Icons.close, color: Colors.red, size: 20),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
