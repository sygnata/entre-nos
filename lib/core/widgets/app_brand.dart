import 'package:flutter/material.dart';

class AppBrand extends StatelessWidget {
  const AppBrand({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = Theme.of(context).textTheme.titleLarge;
    return Semantics(
      label: 'EntreNós',
      child: ExcludeSemantics(
        child: RichText(
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(
                text: 'Entre',
                style: TextStyle(color: colorScheme.onSurface),
              ),
              TextSpan(
                text: 'Nós',
                style: TextStyle(color: colorScheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
