import 'dart:async';

import 'package:applimode_app/src/utils/string_converter.dart';
import 'package:flutter/material.dart';

class MarkdownField extends StatefulWidget {
  const MarkdownField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField> {
  late Timer t;
  @override
  void initState() {
    t = Timer(const Duration(milliseconds: 0), () {});
    widget.controller.addListener(_renderText);
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    widget.controller.removeListener(_renderText);
    super.dispose();
  }

  void _renderText() {
    t.cancel();
    t = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('markdown filed build');
    final itemsList =
        StringConverter.stringToElements(content: widget.controller.text);
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
