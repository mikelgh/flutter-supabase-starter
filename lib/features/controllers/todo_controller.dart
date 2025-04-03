import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repositories/todo_repository.dart';
import '../../core/services/supabase_service.dart';
import '../models/todo_model.dart';

// Todo状态
class TodoState {
  final List<TodoModel> todos;
  final bool isLoading;
  final String? error;

  TodoState({required this.todos, this.isLoading = false, this.error});

  TodoState copyWith({List<TodoModel>? todos, bool? isLoading, String? error}) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Todo 控制器 Provider
final todoControllerProvider = StateNotifierProvider<TodoController, TodoState>(
  (ref) {
    // 这里需要提供一个TodoRepository实例，将在下一步创建provider
    final repository = ref.watch(todoRepositoryProvider);
    return TodoController(repository);
  },
);

// Todo Repository Provider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository(SupabaseService.client);
});

class TodoController extends StateNotifier<TodoState> {
  final TodoRepository _repository;

  TodoController(this._repository)
    : super(TodoState(todos: [], isLoading: false));

  // 获取所有Todo
  Future<void> loadTodos({
    bool onlyActive = false,
    bool onlyCompleted = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final todos = await _repository.getAllTodos(
        onlyActive: onlyActive,
        onlyCompleted: onlyCompleted,
      );
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载Todo失败: $e');
    }
  }

  // 添加新Todo
  Future<void> addTodo(TodoModel todo) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newTodo = await _repository.createTodo(todo);
      if (newTodo != null) {
        state = state.copyWith(
          todos: [...state.todos, newTodo],
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false, error: '添加Todo失败');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '添加Todo失败: $e');
    }
  }

  // 更新Todo
  Future<void> updateTodo(TodoModel todo) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedTodo = await _repository.updateTodo(todo);
      if (updatedTodo != null) {
        final updatedTodos =
            state.todos.map((t) {
              return t.id == updatedTodo.id ? updatedTodo : t;
            }).toList();
        state = state.copyWith(todos: updatedTodos, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: '更新Todo失败');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '更新Todo失败: $e');
    }
  }

  // 删除Todo
  Future<void> deleteTodo(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isDeleted = await _repository.deleteTodo(id);
      if (isDeleted) {
        final updatedTodos = state.todos.where((t) => t.id != id).toList();
        state = state.copyWith(todos: updatedTodos, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: '删除Todo失败');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '删除Todo失败: $e');
    }
  }

  // 切换Todo状态
  Future<void> toggleTodoStatus(String id, bool isCompleted) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedTodo = await _repository.toggleTodoStatus(id, isCompleted);
      if (updatedTodo != null) {
        final updatedTodos =
            state.todos.map((t) {
              return t.id == updatedTodo.id ? updatedTodo : t;
            }).toList();
        state = state.copyWith(todos: updatedTodos, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: '切换Todo状态失败');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '切换Todo状态失败: $e');
    }
  }

  // 筛选Todos
  void filterTodos({bool onlyActive = false, bool onlyCompleted = false}) {
    loadTodos(onlyActive: onlyActive, onlyCompleted: onlyCompleted);
  }

  // 批量标记所有任务为已完成或未完成
  Future<void> markAllTodos(bool isCompleted) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final todos = state.todos;

      for (var todo in todos) {
        if (todo.isCompleted != isCompleted) {
          await _repository.toggleTodoStatus(todo.id, isCompleted);
        }
      }

      // 重新加载所有任务
      await loadTodos();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '批量操作失败: $e');
    }
  }

  // 删除所有已完成的任务
  Future<void> deleteCompletedTodos() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final completedTodos =
          state.todos.where((todo) => todo.isCompleted).toList();

      for (var todo in completedTodos) {
        await _repository.deleteTodo(todo.id);
      }

      // 使用本地数据更新状态，无需重新加载
      final remainingTodos =
          state.todos.where((todo) => !todo.isCompleted).toList();
      state = state.copyWith(todos: remainingTodos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '删除已完成任务失败: $e');
    }
  }
}
