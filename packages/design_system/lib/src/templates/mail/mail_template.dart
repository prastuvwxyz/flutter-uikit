import 'package:flutter/material.dart';
import 'mail_models.dart';

class MailTemplate extends StatefulWidget {
  final List<MailFolder>? folders;
  final List<MailMessage>? messages;
  final MailFolder? selectedFolder;
  final MailMessage? selectedMessage;
  final ValueChanged<MailFolder>? onFolderSelected;
  final ValueChanged<MailMessage>? onMessageSelected;
  final VoidCallback? onCompose;
  final ValueChanged<MailMessage>? onReply;
  final ValueChanged<List<MailMessage>>? onDelete;
  final MailLayout layout;
  final bool searchable;

  const MailTemplate({
    Key? key,
    this.folders,
    this.messages,
    this.selectedFolder,
    this.selectedMessage,
    this.onFolderSelected,
    this.onMessageSelected,
    this.onCompose,
    this.onReply,
    this.onDelete,
    this.layout = MailLayout.adaptive,
    this.searchable = true,
  }) : super(key: key);

  @override
  State<MailTemplate> createState() => _MailTemplateState();
}

class _MailTemplateState extends State<MailTemplate> {
  late MailFolder? _selectedFolder;
  late MailMessage? _selectedMessage;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _selectedFolder = widget.selectedFolder ??
        (widget.folders?.isNotEmpty == true ? widget.folders!.first : null);
    _selectedMessage = widget.selectedMessage;
  }

  void _handleFolderSelected(MailFolder folder) {
    setState(() {
      _selectedFolder = folder;
      _selectedMessage = null;
    });
    widget.onFolderSelected?.call(folder);
  }

  void _handleMessageSelected(MailMessage message) {
    setState(() {
      _selectedMessage = message;
    });
    widget.onMessageSelected?.call(message);
  }

  List<MailMessage> get _filteredMessages {
    final msgs = widget.messages ?? [];
    // For now messages are not foldered; in future filter by folder.id
    if (_search.isEmpty) return msgs;
    final q = _search.toLowerCase();
    return msgs
        .where((m) =>
            m.subject.toLowerCase().contains(q) ||
            m.body.toLowerCase().contains(q) ||
            m.from.toLowerCase().contains(q))
        .toList();
  }

  Widget _buildFolderList() {
    final folders = widget.folders ?? [];
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: widget.onCompose,
            icon: const Icon(Icons.create),
            label: const Text('Compose'),
          ),
        ),
        ...folders.map((f) {
          final selected = _selectedFolder?.id == f.id;
          return ListTile(
            title: Text(f.name),
            leading: selected
                ? const Icon(Icons.folder_open)
                : const Icon(Icons.folder),
            trailing: f.unreadCount > 0
                ? CircleAvatar(radius: 10, child: Text('${f.unreadCount}'))
                : null,
            selected: selected,
            onTap: () => _handleFolderSelected(f),
          );
        }).toList()
      ],
    );
  }

  Widget _buildMessageList() {
    final messages = _filteredMessages;
    if (messages.isEmpty) return const Center(child: Text('No messages'));
    return ListView.separated(
      itemCount: messages.length,
      separatorBuilder: (c, i) => const Divider(height: 1),
      itemBuilder: (c, i) {
        final m = messages[i];
        return ListTile(
          title: Text(m.subject),
          subtitle: Text(
              '${m.from} — ${m.body.length > 80 ? m.body.substring(0, 80) + '…' : m.body}'),
          onTap: () => _handleMessageSelected(m),
        );
      },
    );
  }

  Widget _buildMessageDetail() {
    final m = _selectedMessage;
    if (m == null) return const Center(child: Text('No message selected'));
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(m.subject,
                      style: Theme.of(context).textTheme.titleLarge)),
              IconButton(
                icon: const Icon(Icons.reply),
                onPressed: () => widget.onReply?.call(m),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text('From: ${m.from}'),
          Text('To: ${m.to.join(', ')}'),
          Text('Date: ${m.date}'),
          const Divider(),
          Expanded(child: SingleChildScrollView(child: Text(m.body))),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    if (!widget.searchable) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        key: const Key('mail_search'),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: 'Search mail'),
        onChanged: (v) => setState(() => _search = v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveLayout = widget.layout == MailLayout.adaptive
        ? (MediaQuery.of(context).size.width > 600
            ? MailLayout.sidebar
            : MailLayout.mobile)
        : widget.layout;

    if (effectiveLayout == MailLayout.mobile) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mail')),
        body: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildMessageList()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onCompose,
          child: const Icon(Icons.create),
        ),
      );
    }

    // Sidebar / desktop layout: folders on left, messages middle, detail right
    return Scaffold(
      appBar: AppBar(title: const Text('Mail')),
      body: Row(
        children: [
          SizedBox(width: 260, child: _buildFolderList()),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _buildSearchBar(),
                Expanded(child: _buildMessageList()),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          SizedBox(width: 420, child: _buildMessageDetail()),
        ],
      ),
    );
  }
}
