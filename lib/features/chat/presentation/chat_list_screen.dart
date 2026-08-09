import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/core/constants/app_strings.dart';
import 'package:z_sports_booking/core/theme/app_colors.dart';
import 'package:z_sports_booking/data/mock/mock_data.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.chat),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => context.pop(),
        ),
      ),
      body: MockData.conversations.isEmpty
          ? Center(
              child: Text(
                AppStrings.noMessages,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: MockData.conversations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, index) {
                final chat = MockData.conversations[index];

                return ListTile(
                  onTap: () => context.push('/chat/${chat.id}'),
                  contentPadding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.surfaceBorder),
                  ),
                  tileColor: AppColors.surface,
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(chat.avatarUrl),
                  ),
                  title: Text(
                    chat.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat.time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.background,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
