import 'package:arham_b2c/widgets/common_text.dart';
import 'package:flutter/material.dart';

class CommonNoMessage extends StatelessWidget {
  final String searchQuery;
  final String errorMessage;

  const CommonNoMessage({
    super.key,
    required this.searchQuery,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CommonText(
        text:
            searchQuery.isNotEmpty ? "No search records found." : errorMessage,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        textAlign: TextAlign.center,
      ),
    );
  }
}
