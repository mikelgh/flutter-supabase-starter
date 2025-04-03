import 'package:flutter/material.dart';
import '../../models/note_model.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final bool isGridView;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.note,
    required this.isGridView,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 格式化日期
    final dateFormat = DateFormat('yyyy年MM月dd日');
    final timeFormat = DateFormat('HH:mm');
    final formattedDate = dateFormat.format(note.updatedAt);
    final formattedTime = timeFormat.format(note.updatedAt);

    // 内容预览
    final contentPreview =
        note.content.length > 100
            ? '${note.content.substring(0, 100)}...'
            : note.content;

    return Card(
      clipBehavior: Clip.antiAlias, // 防止内容溢出
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isGridView ? 16.0 : 12.0),
      ),
      elevation: 2.0,
      child: InkWell(
        onTap: onTap,
        child:
            isGridView
                ? _buildGridCard(theme, formattedDate, contentPreview)
                : _buildListCard(
                  theme,
                  formattedDate,
                  formattedTime,
                  contentPreview,
                ),
      ),
    );
  }

  // 网格视图卡片
  Widget _buildGridCard(
    ThemeData theme,
    String formattedDate,
    String contentPreview,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            note.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4.0),

          // 日期
          Text(
            formattedDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),

          const SizedBox(height: 8.0),

          // 内容预览
          Expanded(
            child: Text(
              contentPreview,
              style: theme.textTheme.bodyMedium,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 列表视图卡片
  Widget _buildListCard(
    ThemeData theme,
    String formattedDate,
    String formattedTime,
    String contentPreview,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$formattedDate $formattedTime',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // 内容预览
          Text(
            contentPreview,
            style: theme.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
