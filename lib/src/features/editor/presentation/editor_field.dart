import 'package:flutter/material.dart';

class EditorField extends StatelessWidget {
  const EditorField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: onChanged,
          autocorrect: false,
          enableSuggestions: false,
          expands: true,
        ),
      ),
    );
  }
}
