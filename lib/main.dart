import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/theme/dark_mode.dart';
import 'features/theme/light_mode.dart';
import 'router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Supabase服务
  try {
    await SupabaseService.initialize();
    if (kDebugMode) {
      print('Supabase initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed to initialize Supabase: $e');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI 智能笔记本',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: lightMode.copyWith(
        // 添加一些启动屏幕可能需要的特殊样式
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      darkTheme: darkMode,
    );
  }
}
