import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import 'chat_thread_screen.dart';
import 'new_chat_screen.dart';

class _Conversation {
  _Conversation({
    required this.name,
    required this.preview,
    required this.time,
    required this.unread,
    required this.messages,
    this.isGroup = false,
  });

  final String name;
  String preview;
  String time;
  bool unread;
  final List<ChatMessage> messages;
  final bool isGroup;
}

final _mockConversations = [
  _Conversation(
    name: 'Landlord — Opebi Apartment',
    preview: 'Sure, you can come by this weekend for a viewing.',
    time: '9:41 AM',
    unread: true,
    messages: [
      ChatMessage(
        text: 'Hi, is the 4 bedroom apartment in Opebi still available?',
        fromMe: true,
      ),
      ChatMessage(
        text: 'Yes it is! Would you like to schedule a viewing?',
        fromMe: false,
      ),
      ChatMessage(text: 'Yes please, is this weekend possible?', fromMe: true),
      ChatMessage(
        text: 'Sure, you can come by this weekend for a viewing.',
        fromMe: false,
      ),
    ],
  ),
  _Conversation(
    name: 'Landlord — Agege Flat',
    preview: 'Rent is ₦450,000 per year, agency fee included.',
    time: 'Yesterday',
    unread: false,
    messages: [
      ChatMessage(
        text: 'Hello, what\'s the rent for the 2 bedroom flat?',
        fromMe: true,
      ),
      ChatMessage(
        text: 'Rent is ₦450,000 per year, agency fee included.',
        fromMe: false,
      ),
    ],
  ),
  _Conversation(
    name: 'HomeServant Support',
    preview: 'Let us know if you have any other questions!',
    time: '3 days ago',
    unread: false,
    messages: [
      ChatMessage(
        text: 'How do I update my means of identification?',
        fromMe: true,
      ),
      ChatMessage(
        text: 'You can update it from your profile under Verification.',
        fromMe: false,
      ),
      ChatMessage(
        text: 'Let us know if you have any other questions!',
        fromMe: false,
      ),
    ],
  ),
];

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late final List<_Conversation> _conversations = List.of(_mockConversations);

  Future<void> _startNewChat() async {
    final result = await Navigator.of(
      context,
    ).push<NewChatResult>(MaterialPageRoute(builder: (_) => NewChatScreen(theme: widget.theme)));
    if (result == null || !mounted) return;

    final existingIndex = _conversations.indexWhere((c) => c.name == result.name && c.isGroup == result.isGroup);
    final conversation =
        existingIndex != -1
            ? _conversations[existingIndex]
            : _Conversation(
              name: result.name,
              preview: result.isGroup ? 'Group created — say hi!' : 'Say hi to ${result.name}!',
              time: 'Now',
              unread: false,
              isGroup: result.isGroup,
              messages: [],
            );

    if (existingIndex == -1) {
      setState(() => _conversations.insert(0, conversation));
    }
    if (!mounted) return;
    await _openThread(conversation);
  }

  Future<void> _openThread(_Conversation convo) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatThreadScreen(theme: widget.theme, contactName: convo.name, initialMessages: convo.messages),
      ),
    );
    if (!mounted) return;
    setState(() => convo.unread = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text(
          'Messages',
          style: AppTextStyles.heading(color: theme.foreground, size: 18),
        ),
        actions: [
          IconButton(
            onPressed: _startNewChat,
            icon: Icon(Icons.add_comment_outlined, color: theme.foreground),
            tooltip: 'New message',
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child:
              _conversations.isEmpty
                  ? Center(
                    child: Text(
                      'No conversations yet — tap the icon above to message someone.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6)),
                    ),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: _conversations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final convo = _conversations[index];
                      return GestureDetector(
                        onTap: () => _openThread(convo),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.surface,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: theme.accent.withValues(alpha: 0.25),
                                child: Icon(
                                  convo.isGroup ? Icons.groups_rounded : Icons.person,
                                  color: theme.accent,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            convo.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.body(
                                              color: theme.onSurface,
                                              size: 14,
                                              weight: convo.unread ? FontWeight.w800 : FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          convo.time,
                                          style: AppTextStyles.body(
                                            color: theme.onSurface.withValues(alpha: 0.5),
                                            size: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      convo.preview,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.body(
                                        color: theme.onSurface.withValues(alpha: convo.unread ? 0.9 : 0.6),
                                        size: 13,
                                        weight: convo.unread ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (convo.unread) ...[
                                const SizedBox(width: 8),
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: BoxDecoration(color: theme.accent, shape: BoxShape.circle),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
