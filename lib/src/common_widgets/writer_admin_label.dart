import 'package:applimode_app/custom_settings.dart';
import 'package:flutter/material.dart';

class WriterAdminLabel extends StatelessWidget {
  const WriterAdminLabel({
    super.key,
    this.labelSize,
  });

  final double? labelSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Color(userAdminColor),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.star,
        size: labelSize ?? 10,
        color: Colors.white,
      ),
    );
  }
}
