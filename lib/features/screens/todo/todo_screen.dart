import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/todo_form.dart';
import '../../components/todo_item.dart';
import '../../controllers/todo_controller.dart';
import '../../models/todo_model.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

// 任务显示类型枚举
enum TodoFilterType {
  all('全部'),
  active('未完成'),
  completed('已完成');

  final String label;
  const TodoFilterType(this.label);
}

class _TodoScreenState extends ConsumerState<TodoScreen>
    with SingleTickerProviderStateMixin {
  // 当前选中的筛选类型
  TodoFilterType _currentFilterType = TodoFilterType.active;

  // 标签控制器
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // 初始化标签控制器
    _tabController = TabController(
      length: TodoFilterType.values.length,
      vsync: this,
      initialIndex: _currentFilterType.index,
    );

    // 监听标签变化
    _tabController.addListener(_handleTabChange);

    // 在下一帧加载数据，避免在build过程中调用setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodosBasedOnFilter();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  // 处理标签变化
  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentFilterType = TodoFilterType.values[_tabController.index];
      });
      _loadTodosBasedOnFilter();
    }
  }

  // 根据筛选类型加载Todo
  void _loadTodosBasedOnFilter() {
    switch (_currentFilterType) {
      case TodoFilterType.all:
        ref.read(todoControllerProvider.notifier).loadTodos();
        break;
      case TodoFilterType.active:
        ref.read(todoControllerProvider.notifier).loadTodos(onlyActive: true);
        break;
      case TodoFilterType.completed:
        ref
            .read(todoControllerProvider.notifier)
            .loadTodos(onlyCompleted: true);
        break;
    }
  }

  void _showAddTodoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const SingleChildScrollView(child: TodoForm()),
        );
      },
    );
  }

  void _showEditTodoBottomSheet(TodoModel todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(child: TodoForm(todo: todo)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoControllerProvider);
    final theme = Theme.of(context);

    // 处理错误
    if (todoState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('错误: ${todoState.error}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '重试',
              onPressed: () {
                _loadTodosBasedOnFilter();
              },
            ),
          ),
        );
      });
    }

    return WillPopScope(
      onWillPop: () async {
        // 如果正在加载，阻止返回
        if (todoState.isLoading) {
          return false;
        }
        // 否则允许返回
        context.go('/home');
        return false; // 我们手动处理导航，所以返回false
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade900,
          title: const Text('我的任务'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // 如果正在加载，显示提示
              if (todoState.isLoading) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('请等待当前操作完成')));
                return;
              }
              // 否则返回首页
              context.go('/home');
            },
          ),
          actions: [
            // 如果是在已完成标签页，显示清空按钮
            if (_currentFilterType == TodoFilterType.completed &&
                todoState.todos.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: '清空已完成',
                onPressed: () {
                  _showClearCompletedDialog(context);
                },
              ),

            // 添加批量操作按钮
            if (todoState.todos.isNotEmpty)
              PopupMenuButton<String>(
                tooltip: '批量操作',
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'mark_all_done':
                      _showMarkAllDialog(context, true);
                      break;
                    case 'mark_all_undone':
                      _showMarkAllDialog(context, false);
                      break;
                    case 'clear_completed':
                      _showClearCompletedDialog(context);
                      break;
                  }
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'mark_all_done',
                        child: Row(
                          children: [
                            Icon(Icons.done_all, size: 20),
                            SizedBox(width: 8),
                            Text('全部标记为已完成'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'mark_all_undone',
                        child: Row(
                          children: [
                            Icon(Icons.remove_done, size: 20),
                            SizedBox(width: 8),
                            Text('全部标记为未完成'),
                          ],
                        ),
                      ),
                      if (_currentFilterType != TodoFilterType.completed)
                        const PopupMenuItem(
                          value: 'clear_completed',
                          child: Row(
                            children: [
                              Icon(Icons.delete_sweep, size: 20),
                              SizedBox(width: 8),
                              Text('清除已完成任务'),
                            ],
                          ),
                        ),
                    ],
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              alignment: Alignment.center,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.5),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                indicatorWeight: 4,
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                dividerColor: Colors.transparent,
                tabs:
                    TodoFilterType.values.map((type) {
                      final isSelected = _currentFilterType == type;
                      return Tab(
                        height: 40,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          constraints: const BoxConstraints(minWidth: 100),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? theme.colorScheme.primary.withOpacity(0.3)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border:
                                isSelected
                                    ? Border.all(color: Colors.white, width: 1)
                                    : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildTabIcon(type),
                              const SizedBox(width: 8),
                              Text(type.label),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
        body:
            todoState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : todoState.todos.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: todoState.todos.length,
                  itemBuilder: (context, index) {
                    final todo = todoState.todos[index];
                    return TodoItem(
                      todo: todo,
                      onTodoTap: _showEditTodoBottomSheet,
                    );
                  },
                ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTodoBottomSheet,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // 根据筛选类型构建不同的图标
  Widget _buildTabIcon(TodoFilterType type) {
    final isSelected = _currentFilterType == type;
    final color = isSelected ? Colors.white : Colors.white.withOpacity(0.5);

    switch (type) {
      case TodoFilterType.all:
        return Icon(Icons.list_alt, size: 22, color: color);
      case TodoFilterType.active:
        return Icon(Icons.check_box_outline_blank, size: 22, color: color);
      case TodoFilterType.completed:
        return Icon(Icons.check_box, size: 22, color: color);
    }
  }

  Widget _buildEmptyState() {
    String message;
    switch (_currentFilterType) {
      case TodoFilterType.all:
        message = '没有任务';
        break;
      case TodoFilterType.active:
        message = '没有未完成的任务';
        break;
      case TodoFilterType.completed:
        message = '没有已完成的任务';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('创建新任务'),
            onPressed: _showAddTodoBottomSheet,
          ),
        ],
      ),
    );
  }

  // 显示清空已完成任务的确认对话框
  void _showClearCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('清空已完成任务'),
            content: const Text('确定要删除所有已完成的任务吗？此操作无法撤销。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearCompletedTodos();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('删除'),
              ),
            ],
          ),
    );
  }

  // 清空已完成任务的方法
  void _clearCompletedTodos() {
    ref.read(todoControllerProvider.notifier).deleteCompletedTodos();
  }

  // 显示全部标记为已完成或未完成的确认对话框
  void _showMarkAllDialog(BuildContext context, bool markAsDone) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(markAsDone ? '全部标记为已完成' : '全部标记为未完成'),
            content: Text(markAsDone ? '确定要将所有任务标记为已完成吗？' : '确定要将所有任务标记为未完成吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref
                      .read(todoControllerProvider.notifier)
                      .markAllTodos(markAsDone);
                },
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }
}
