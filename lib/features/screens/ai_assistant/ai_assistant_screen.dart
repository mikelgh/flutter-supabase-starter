import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // 模拟消息列表
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: '你好！我是你的AI助手，有什么我可以帮你的吗？',
      isUserMessage: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  // 常用提示词
  final List<String> _quickPrompts = [
    '总结这篇笔记',
    '生成一个学习计划',
    '帮我润色文章',
    '解释这个概念',
    '翻译成英文',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 发送消息
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: _messageController.text,
      isUserMessage: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
    });

    // 滚动到底部
    _scrollToBottom();

    // 模拟AI回复
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final aiMessage = ChatMessage(
        text: '我收到了你的消息："${userMessage.text}"。这是一个AI模拟回复，实际应用中这里会调用AI API。',
        isUserMessage: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
      });

      // 滚动到底部
      _scrollToBottom();
    });
  }

  // 滚动到底部
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 对话历史
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // 快捷提示词区域
          if (_quickPrompts.isNotEmpty)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickPrompts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      label: Text(_quickPrompts[index]),
                      onPressed: () {
                        setState(() {
                          _messageController.text = _quickPrompts[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),

          // 分隔线
          const Divider(height: 1),

          // 输入区域
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 文本输入框
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: '询问AI助手...',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),

                const SizedBox(width: 8.0),

                // 语音输入按钮
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    // TODO: 实现语音输入功能
                  },
                  tooltip: '语音输入',
                ),

                // 发送按钮
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  tooltip: '发送',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建消息气泡
  Widget _buildMessageBubble(ChatMessage message) {
    final timeFormat = DateFormat('HH:mm');
    final formattedTime = timeFormat.format(message.timestamp);

    return Align(
      alignment:
          message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              message.isUserMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color:
                    message.isUserMessage
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color:
                      message.isUserMessage
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                formattedTime,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (!message.isUserMessage)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      onPressed: () {
                        // TODO: 实现复制功能
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('文本已复制')));
                      },
                      tooltip: '复制',
                    ),
                    IconButton(
                      icon: const Icon(Icons.note_add, size: 20),
                      onPressed: () {
                        // TODO: 实现添加到笔记功能
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('已添加到笔记')));
                      },
                      tooltip: '添加到笔记',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 聊天消息模型
class ChatMessage {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
  });
}
