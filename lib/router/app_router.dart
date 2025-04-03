import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/supabase_service.dart';
import '../core/repositories/auth_repository.dart';
import '../features/controllers/auth_screen_controller.dart';
import '../features/controllers/home_screen_controller.dart';
import '../features/screens/splash_screen.dart';
import '../features/screens/todo/todo_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: true, // 开启路由日志，便于调试
  redirect: (context, state) async {
    // 跳过重定向逻辑，如果是splash页面
    if (state.fullPath == '/splash') {
      return null;
    }

    // 确保Supabase已初始化
    await SupabaseService.initialize();
    final authRepository = AuthRepository(SupabaseService.client);
    final isLoggedIn = authRepository.currentUser != null;

    // 验证用户登录状态和路由逻辑
    if (isLoggedIn) {
      // 已登录用户，如果访问根路径，重定向到主页
      if (state.fullPath == '/') {
        return '/home';
      }
    } else {
      // 未登录用户，如果不是访问根路径或闪屏，重定向到登录页
      if (state.fullPath != '/' && !state.fullPath!.startsWith('/splash')) {
        return '/';
      }
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreenController(),
    ),
    GoRoute(
      path: '/todo',
      pageBuilder:
          (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const TodoScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
          ),
    ),
  ],
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('页面未找到')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('页面不存在或发生错误', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => GoRouter.of(context).go('/home'),
                child: const Text('返回首页'),
              ),
            ],
          ),
        ),
      ),
);
