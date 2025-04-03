import 'package:flutter/material.dart';
import '../../models/note_model.dart';

class EditorScreen extends StatefulWidget {
  final bool isNewNote;
  final NoteModel? note;

  const EditorScreen({super.key, required this.isNewNote, this.note});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isAIAssistPanelVisible = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.isNewNote ? '' : widget.note?.title,
    );
    _contentController = TextEditingController(
      text: widget.isNewNote ? '' : widget.note?.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // 保存笔记
  void _saveNote() {
    // TODO: 实现笔记保存逻辑
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('笔记已保存')));
  }

  // 显示AI助手面板
  void _toggleAIAssistPanel() {
    setState(() {
      _isAIAssistPanelVisible = !_isAIAssistPanelVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 标题输入区域
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(
                hintText: '输入标题',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
              maxLines: 1,
            ),
          ),

          // 分隔线
          const Divider(height: 1),

          // 编辑区域
          Expanded(
            child: Row(
              children: [
                // 笔记内容编辑区
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _contentController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: '开始写笔记...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ),

                // AI助手面板（可折叠）
                if (_isAIAssistPanelVisible)
                  Container(
                    width: 280,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      border: Border(
                        left: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 面板标题
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.lightbulb_outline),
                              const SizedBox(width: 8),
                              Text(
                                'AI 助手建议',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: _toggleAIAssistPanel,
                                tooltip: '关闭',
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1),

                        // AI建议按钮
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(16.0),
                            children: [
                              _buildAIActionButton('总结内容', Icons.summarize, () {
                                // TODO: 实现AI总结功能
                              }),
                              _buildAIActionButton(
                                '润色文本',
                                Icons.auto_fix_high,
                                () {
                                  // TODO: 实现AI润色功能
                                },
                              ),
                              _buildAIActionButton(
                                'AI续写',
                                Icons.add_circle_outline,
                                () {
                                  // TODO: 实现AI续写功能
                                },
                              ),
                              _buildAIActionButton('自动翻译', Icons.translate, () {
                                // TODO: 实现翻译功能
                              }),
                              _buildAIActionButton(
                                '语法检查',
                                Icons.spellcheck,
                                () {
                                  // TODO: 实现语法检查功能
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // 工具栏
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // 格式工具
                IconButton(
                  icon: const Icon(Icons.format_bold),
                  onPressed: () {
                    // TODO: 实现加粗功能
                  },
                  tooltip: '加粗',
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic),
                  onPressed: () {
                    // TODO: 实现斜体功能
                  },
                  tooltip: '斜体',
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted),
                  onPressed: () {
                    // TODO: 实现列表功能
                  },
                  tooltip: '列表',
                ),

                const Spacer(),

                // AI助手按钮
                TextButton.icon(
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: const Text('AI助手'),
                  onPressed: _toggleAIAssistPanel,
                ),

                // 保存按钮
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('保存'),
                  onPressed: _saveNote,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AI操作按钮
  Widget _buildAIActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}
