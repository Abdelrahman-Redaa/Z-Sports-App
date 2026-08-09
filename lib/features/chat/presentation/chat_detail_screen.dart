import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';
import 'package:z_sports_booking/data/models/chat_model.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversation = MockData.conversationById(widget.conversationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(conversation.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: conversation.messages.length,
              itemBuilder: (_, index) {
                final message = conversation.messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: AppStrings.typeMessage,
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _messageController.clear(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.background,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSent;

    return Align(
      alignment: isSent
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isSent
              ? AppColors.chatBubbleSent
              : AppColors.chatBubbleReceived,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSent ? 4 : 16),
            bottomRight: Radius.circular(isSent ? 16 : 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSent ? AppColors.background : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSent
                    ? AppColors.background.withValues(alpha: 0.7)
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
