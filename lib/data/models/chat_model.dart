class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isSent,
    required this.time,
  });

  final String id;
  final String text;
  final bool isSent;
  final String time;
}

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.messages,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final List<ChatMessage> messages;
}
