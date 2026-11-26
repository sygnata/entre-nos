import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class EntreNosApp extends StatelessWidget {
  const EntreNosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EntreNós',
      debugShowCheckedModeBanner: false,
      theme: EntreNosTheme.light,
      darkTheme: EntreNosTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
