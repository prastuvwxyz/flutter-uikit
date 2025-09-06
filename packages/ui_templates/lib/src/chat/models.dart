// Minimal models for ChatTemplate

enum ChatLayout { adaptive, sidebar, mobile }

class ChatUser {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool online;

  const ChatUser({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.online = false,
  });
}

class ChatMessage {
  final String id;
  final String conversationId;
  final ChatUser sender;
  final String text;
  final DateTime timestamp;
  final bool mine;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.mine = false,
  });
}

class ChatConversation {
  final String id;
  final String title;
  final List<ChatUser> participants;
  final int unreadCount;

  const ChatConversation({
    required this.id,
    required this.title,
    this.participants = const [],
    this.unreadCount = 0,
  });
}
