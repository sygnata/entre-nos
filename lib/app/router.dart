import 'package:go_router/go_router.dart';

import '../features/bootstrap/presentation/bootstrap_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const BootstrapScreen()),
  ],
);
