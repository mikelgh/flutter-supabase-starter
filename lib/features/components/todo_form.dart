import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class TodoForm extends ConsumerStatefulWidget {
  final TodoModel? todo;

  const TodoForm({super.key, this.todo});

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  int _priority = 0;
  Color _selectedColor = Colors.green;
  bool _isCompleted = false;

  // 颜色选项
  final List<Color> _colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    // 如果是编辑现有Todo，则填充表单
    final todo = widget.todo;
    _titleController = TextEditingController(text: todo?.title ?? '');
    _descriptionController = TextEditingController(
      text: todo?.description ?? '',
    );
    _dueDate = todo?.dueDate;
    _priority = todo?.priority ?? 0;
    _isCompleted = todo?.isCompleted ?? false;

    // 从整数颜色值设置颜色对象
    if (todo?.color != null) {
      _selectedColor = Color(todo!.color!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final todo = TodoModel(
        id: widget.todo?.id ?? '', // 如果是新建，id会在仓库层被移除
        userId: widget.todo?.userId ?? '',
        title: _titleController.text,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
        isCompleted: _isCompleted,
        priority: _priority,
        color: _selectedColor.value, // 存储颜色对象的value值
        dueDate: _dueDate,
        createdAt: widget.todo?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.todo == null) {
        // 创建新Todo
        ref.read(todoControllerProvider.notifier).addTodo(todo);
      } else {
        // 更新现有Todo
        ref.read(todoControllerProvider.notifier).updateTodo(todo);
      }

      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题输入
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 描述输入
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述 (可选)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // 优先级选择
            Row(
              children: [
                const Text('优先级: '),
                const SizedBox(width: 16),
                ChoiceChip(
                  label: const Text('无'),
                  selected: _priority == 0,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _priority = 0;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('低'),
                  selected: _priority == 1,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _priority = 1;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('中'),
                  selected: _priority == 2,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _priority = 2;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('高'),
                  selected: _priority == 3,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _priority = 3;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 截止日期选择
            Row(
              children: [
                const Text('截止日期: '),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _dueDate == null
                        ? '选择日期'
                        : DateFormat('yyyy-MM-dd').format(_dueDate!),
                  ),
                ),
                if (_dueDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _dueDate = null;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // 颜色选择
            Row(
              children: [
                const Text('颜色: '),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colorOptions.length,
                      itemBuilder: (context, index) {
                        final color = _colorOptions[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      _selectedColor == color
                                          ? Colors.black
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 完成状态切换
            if (widget.todo != null) // 仅在编辑模式下显示
              Row(
                children: [
                  const Text('状态: '),
                  const SizedBox(width: 16),
                  Switch(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value;
                      });
                    },
                  ),
                  Text(_isCompleted ? '已完成' : '未完成'),
                ],
              ),
            const SizedBox(height: 24),

            // 提交按钮
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(widget.todo == null ? '创建任务' : '保存修改'),
            ),
          ],
        ),
      ),
    );
  }
}
