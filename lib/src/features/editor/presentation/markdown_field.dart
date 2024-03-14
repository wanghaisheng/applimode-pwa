import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:flutter/material.dart';

class MarkdownField extends StatelessWidget {
  const MarkdownField({
    super.key,
    required this.data,
    required this.bottomBarHeight,
  });

  final String data;
  final double bottomBarHeight;

  @override
  Widget build(BuildContext context) {
    final itemsList = StringConverter.stringToElements(content: data);
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemsList.length,
        itemBuilder: (context, index) {
          return itemsList[index];
        },
      ),
    );
  }
}
