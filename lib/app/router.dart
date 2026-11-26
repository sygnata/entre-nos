import 'package:go_router/go_router.dart';

import '../features/auth/presentation/auth_gate.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const AuthGate()),
  ],
);
