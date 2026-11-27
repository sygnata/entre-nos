import 'package:flutter/material.dart';

import '../../app/theme.dart';

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = context.entreNosTokens;
    return Card(
      color: tokens.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: tokens.cardRadius),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
