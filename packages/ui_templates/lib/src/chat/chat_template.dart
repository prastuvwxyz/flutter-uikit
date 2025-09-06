import 'package:flutter/material.dart';
import 'models.dart';

typedef ValueChanged<T> = void Function(T value);

class ChatTemplate extends StatefulWidget {
  final List<ChatConversation>? conversations;
  final List<ChatMessage>? messages;
  final ChatUser? currentUser;
  final ChatConversation? activeConversation;
  final ValueChanged<ChatConversation>? onConversationSelected;
  final ValueChanged<String>? onMessageSent;
  final ValueChanged<bool>? onTyping;
  final List<ChatUser> typingUsers;
  final ChatLayout layout;
  final bool showUserList;

  const ChatTemplate({
    Key? key,
    this.conversations,
    this.messages,
    this.currentUser,
    this.activeConversation,
    this.onConversationSelected,
    this.onMessageSent,
    this.onTyping,
    this.typingUsers = const [],
    this.layout = ChatLayout.adaptive,
    this.showUserList = true,
  }) : super(key: key);

  @override
  State<ChatTemplate> createState() => _ChatTemplateState();
}

class _ChatTemplateState extends State<ChatTemplate> {
  final TextEditingController _controller = TextEditingController();
  bool _typing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onMessageSent?.call(text);
    _controller.clear();
    setState(() => _typing = false);
    widget.onTyping?.call(false);
  }

  @override
  Widget build(BuildContext context) {
    final conversations = widget.conversations ?? const [];
    final messages = widget.messages ?? const [];

    return Row(
      children: [
        // Conversations list
        Flexible(
          flex: 2,
          child: Container(
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, i) {
                final c = conversations[i];
                return ListTile(
                  title: Text(c.title),
                  trailing: c.unreadCount > 0
                      ? CircleAvatar(
                          radius: 10,
                          child: Text('${c.unreadCount}',
                              style: TextStyle(fontSize: 10)),
                        )
                      : null,
                  selected: widget.activeConversation?.id == c.id,
                  onTap: () => widget.onConversationSelected?.call(c),
                );
              },
            ),
          ),
        ),

        // Chat area
        Flexible(
          flex: 5,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[messages.length - 1 - i];
                    final mine = widget.currentUser != null &&
                            m.sender.id == widget.currentUser!.id ||
                        m.mine;
                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: mine
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(m.text,
                            style: TextStyle(
                                color: mine
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface)),
                      ),
                    );
                  },
                ),
              ),

              // Typing indicators
              if (widget.typingUsers.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                      '${widget.typingUsers.map((u) => u.name).join(', ')} is typing...'),
                ),

              // Input
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (v) {
                            final t = v.trim().isNotEmpty;
                            if (t != _typing) {
                              setState(() => _typing = t);
                              widget.onTyping?.call(t);
                            }
                          },
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(hintText: 'Message'),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.send), onPressed: _send),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Optional user list
        if (widget.showUserList)
          Flexible(
            flex: 2,
            child: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: ListView(
                children:
                    (widget.activeConversation?.participants ?? []).map((u) {
                  return ListTile(
                    leading: CircleAvatar(
                        child: Text(u.name.isNotEmpty ? u.name[0] : '?')),
                    title: Text(u.name),
                    subtitle: Text(u.online ? 'online' : 'offline'),
                    onTap: () {},
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
