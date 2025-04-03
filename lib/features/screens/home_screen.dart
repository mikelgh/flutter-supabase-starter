import 'package:flutter/material.dart';
import 'notes/notes_screen.dart';
import 'editor/editor_screen.dart';
import 'ai_assistant/ai_assistant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // 用于存储页面的列表
  final List<Widget> _screens = [
    const NotesScreen(),
    const EditorScreen(isNewNote: true),
    const AIAssistantScreen(),
  ];

  // 页面标题列表
  final List<String> _titles = ['我的笔记', '新建笔记', 'AI助手'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        elevation: 0,
        actions: [
          if (_currentIndex == 0) // 仅在笔记列表页显示搜索按钮
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // 实现搜索功能
              },
            ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              // 导航到个人资料页面
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  // 切换到编辑页面
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: '笔记',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_outlined),
            activeIcon: Icon(Icons.edit),
            label: '编辑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            activeIcon: Icon(Icons.smart_toy),
            label: 'AI助手',
          ),
        ],
      ),
    );
  }
}
