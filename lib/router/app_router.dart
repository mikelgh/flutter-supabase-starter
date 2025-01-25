import 'package:go_router/go_router.dart';
import '../core/services/supabase_service.dart';
import '../core/repositories/auth_repository.dart';
import '../features/controllers/auth_screen_controller.dart';
import '../features/controllers/home_screen_controller.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    await SupabaseService.initialize();
    final authRepository = AuthRepository(SupabaseService.client);
    final isLoggedIn = authRepository.currentUser != null;

    if (isLoggedIn) {
      if (state.fullPath == '/') {
        return '/home';
      }
    } else {
      if (state.fullPath == '/home') {
        return '/';
      }
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreenController()),
  ],
);
