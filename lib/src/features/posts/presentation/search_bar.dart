import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onComplete,
  });

  final TextEditingController controller;
  final VoidCallback? onComplete;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: TextField(
                controller: widget.controller,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: context.loc.tagSearch,
                  // hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
                onEditingComplete: () {
                  widget.onComplete?.call();
                },
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            widget.onComplete?.call();
          },
          icon: const Icon(Icons.search_outlined),
        )
      ],
    );
  }
}
