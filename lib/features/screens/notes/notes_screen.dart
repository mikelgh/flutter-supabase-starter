import 'package:flutter/material.dart';
import '../../components/notes/note_card.dart';
import '../../models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isGridView = true; // 控制视图模式：网格或列表

  // 模拟笔记数据
  final List<NoteModel> _notes = [
    NoteModel(
      id: '1',
      title: '会议笔记',
      content: '今天的团队会议讨论了新产品的开发计划，重点关注用户体验和性能优化...',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NoteModel(
      id: '2',
      title: '学习计划',
      content: '本周学习目标：Flutter高级动画，Supabase数据库集成，Firebase消息推送...',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NoteModel(
      id: '3',
      title: '购物清单',
      content: '1. 水果：苹果、香蕉、橙子\n2. 蔬菜：西红柿、黄瓜、青椒\n3. 零食：坚果、饼干...',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    NoteModel(
      id: '4',
      title: 'AI学习资源',
      content:
          '推荐的AI学习网站：\n1. Coursera - 机器学习课程\n2. Fast.ai - 深度学习实践\n3. TensorFlow官方教程...',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NoteModel(
      id: '5',
      title: '项目想法',
      content: '1. AI智能笔记应用 - 使用NLP技术自动整理和总结笔记内容\n2. 健康追踪App - 结合可穿戴设备数据...',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部工具栏
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // 排序选项
              const Expanded(
                child: Text(
                  '按最近编辑排序',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              // 切换视图按钮
              IconButton(
                icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
            ],
          ),
        ),

        // 笔记列表
        Expanded(
          child:
              _isGridView
                  ? GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return NoteCard(
                        note: _notes[index],
                        isGridView: true,
                        onTap: () {
                          // 导航到笔记编辑页面
                        },
                      );
                    },
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NoteCard(
                          note: _notes[index],
                          isGridView: false,
                          onTap: () {
                            // 导航到笔记编辑页面
                          },
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
