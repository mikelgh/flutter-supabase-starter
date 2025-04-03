import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/models/todo_model.dart';

class TodoRepository {
  final SupabaseClient _supabaseClient;
  final String _tableName = 'todos';

  TodoRepository(this._supabaseClient);

  // 获取所有Todo项
  Future<List<TodoModel>> getAllTodos({
    bool onlyActive = false,
    bool onlyCompleted = false,
  }) async {
    try {
      final query = _supabaseClient.from(_tableName).select();

      // 先过滤出当前用户的Todos
      var filteredQuery = query.eq(
        'user_id',
        _supabaseClient.auth.currentUser!.id,
      );

      // 根据完成状态进一步过滤
      if (onlyActive) {
        filteredQuery = filteredQuery.eq('is_completed', false);
      } else if (onlyCompleted) {
        filteredQuery = filteredQuery.eq('is_completed', true);
      }

      final response = await filteredQuery
          .order('priority', ascending: false)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((data) => TodoModel.fromJson(data))
          .toList();
    } catch (e) {
      print('获取Todo失败: $e');
      return [];
    }
  }

  // 获取单个Todo项
  Future<TodoModel?> getTodo(String id) async {
    try {
      final response =
          await _supabaseClient.from(_tableName).select().eq('id', id).single();

      return TodoModel.fromJson(response);
    } catch (e) {
      print('获取单个Todo失败: $e');
      return null;
    }
  }

  // 创建Todo项
  Future<TodoModel?> createTodo(TodoModel todo) async {
    try {
      final Map<String, dynamic> data = todo.toJson();
      // 使用当前登录用户的ID
      data['user_id'] = _supabaseClient.auth.currentUser!.id;

      // 移除id字段，让数据库自动生成
      data.remove('id');

      // 设置创建和更新时间
      final now = DateTime.now().toIso8601String();
      data['created_at'] = now;
      data['updated_at'] = now;

      final response =
          await _supabaseClient.from(_tableName).insert(data).select().single();

      return TodoModel.fromJson(response);
    } catch (e) {
      print('创建Todo失败: $e');
      return null;
    }
  }

  // 更新Todo项
  Future<TodoModel?> updateTodo(TodoModel todo) async {
    try {
      final Map<String, dynamic> data = todo.toJson();
      // 更新时间
      data['updated_at'] = DateTime.now().toIso8601String();

      final response =
          await _supabaseClient
              .from(_tableName)
              .update(data)
              .eq('id', todo.id)
              .select()
              .single();

      return TodoModel.fromJson(response);
    } catch (e) {
      print('更新Todo失败: $e');
      return null;
    }
  }

  // 删除Todo项
  Future<bool> deleteTodo(String id) async {
    try {
      await _supabaseClient.from(_tableName).delete().eq('id', id);

      return true;
    } catch (e) {
      print('删除Todo失败: $e');
      return false;
    }
  }

  // 切换Todo的完成状态
  Future<TodoModel?> toggleTodoStatus(String id, bool isCompleted) async {
    try {
      final response =
          await _supabaseClient
              .from(_tableName)
              .update({
                'is_completed': isCompleted,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', id)
              .select()
              .single();

      return TodoModel.fromJson(response);
    } catch (e) {
      print('切换Todo状态失败: $e');
      return null;
    }
  }
}
