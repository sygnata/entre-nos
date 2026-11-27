import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'app_brand.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    required this.children,
    super.key,
    this.actions,
  });

  final String title;
  final List<Widget> children;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final tokens = context.entreNosTokens;
    return Semantics(
      label: title,
      child: Scaffold(
        appBar: AppBar(title: const AppBrand(), actions: actions),
        body: SafeArea(
          child: ListView(padding: tokens.pagePadding, children: children),
        ),
      ),
    );
  }
}
