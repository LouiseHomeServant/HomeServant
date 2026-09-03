import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import 'chat_thread_screen.dart';

class _Conversation {
  const _Conversation({
    required this.name,
    required this.preview,
    required this.time,
    required this.unread,
    required this.messages,
  });

  final String name;
  final String preview;
  final String time;
  final bool unread;
  final List<ChatMessage> messages;
}

final _mockConversations = [
  _Conversation(
    name: 'Landlord — Opebi Apartment',
    preview: 'Sure, you can come by this weekend for a viewing.',
    time: '9:41 AM',
    unread: true,
    messages: [
      ChatMessage(text: 'Hi, is the 4 bedroom apartment in Opebi still available?', fromMe: true),
      ChatMessage(text: 'Yes it is! Would you like to schedule a viewing?', fromMe: false),
      ChatMessage(text: 'Yes please, is this weekend possible?', fromMe: true),
      ChatMessage(text: 'Sure, you can come by this weekend for a viewing.', fromMe: false),
    ],
  ),
  _Conversation(
    name: 'Landlord — Agege Flat',
    preview: 'Rent is ₦450,000 per year, agency fee included.',
    time: 'Yesterday',
    unread: false,
    messages: [
      ChatMessage(text: 'Hello, what\'s the rent for the 2 bedroom flat?', fromMe: true),
      ChatMessage(text: 'Rent is ₦450,000 per year, agency fee included.', fromMe: false),
    ],
  ),
  _Conversation(
    name: 'HomeServant Support',
    preview: 'Let us know if you have any other questions!',
    time: '3 days ago',
    unread: false,
    messages: [
      ChatMessage(text: 'How do I update my means of identification?', fromMe: true),
      ChatMessage(text: 'You can update it from your profile under Verification.', fromMe: false),
      ChatMessage(text: 'Let us know if you have any other questions!', fromMe: false),
    ],
  ),
];

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.foreground),
        title: Text('Messages', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: _mockConversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final convo = _mockConversations[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatThreadScreen(
                    theme: theme,
                    contactName: convo.name,
                    initialMessages: convo.messages,
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.accent.withValues(alpha: 0.25),
                      child: Icon(Icons.person, color: theme.accent),
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
                              Text(convo.time, style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.5), size: 11)),
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
                      Container(width: 9, height: 9, decoration: BoxDecoration(color: theme.accent, shape: BoxShape.circle)),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
