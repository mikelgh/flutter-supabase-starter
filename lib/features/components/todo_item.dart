import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'todo_form.dart';

class TodoItem extends ConsumerWidget {
  final TodoModel todo;
  final Function(TodoModel) onTodoTap;

  const TodoItem({super.key, required this.todo, required this.onTodoTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 确保color是int类型，默认绿色
    final int colorValue =
        todo.color != null ? (todo.color as int) : 0xFF4CAF50;
    final color = Color(colorValue);
    final textTheme = Theme.of(context).textTheme;

    // 格式化日期
    String formattedDate = '';
    if (todo.dueDate != null) {
      final dateFormat = DateFormat('yyyy-MM-dd');
      formattedDate = dateFormat.format(todo.dueDate!);
    }

    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        ref.read(todoControllerProvider.notifier).deleteTodo(todo.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已删除 "${todo.title}"'),
            action: SnackBarAction(
              label: '撤销',
              onPressed: () {
                ref.read(todoControllerProvider.notifier).addTodo(todo);
              },
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            activeColor: color,
            onChanged: (value) {
              ref
                  .read(todoControllerProvider.notifier)
                  .toggleTodoStatus(todo.id, value ?? false);
            },
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration:
                  todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
              color: todo.isCompleted ? Colors.grey : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description != null && todo.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    todo.description!,
                    style: TextStyle(
                      decoration:
                          todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      color: todo.isCompleted ? Colors.grey : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    if (formattedDate.isNotEmpty) ...[
                      const Icon(Icons.calendar_today, size: 14),
                      const SizedBox(width: 4),
                      Text(formattedDate, style: textTheme.bodySmall),
                      const SizedBox(width: 12),
                    ],
                    _buildPriorityChip(todo.priority ?? 0),
                  ],
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => onTodoTap(todo),
          ),
          onTap: () => onTodoTap(todo),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(int priority) {
    Color chipColor;
    String label;

    switch (priority) {
      case 3:
        chipColor = Colors.red;
        label = '高';
        break;
      case 2:
        chipColor = Colors.orange;
        label = '中';
        break;
      case 1:
        chipColor = Colors.yellow;
        label = '低';
        break;
      case 0:
      default:
        chipColor = Colors.grey;
        label = '无';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: chipColor)),
    );
  }
}
