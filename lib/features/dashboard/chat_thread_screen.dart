import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import '../../widgets/pill_text_field.dart';

class ChatMessage {
  ChatMessage({required this.text, required this.fromMe});

  final String text;
  final bool fromMe;
}

class ChatThreadScreen extends StatefulWidget {
  const ChatThreadScreen({
    super.key,
    required this.theme,
    required this.contactName,
    required this.initialMessages,
  });

  final DashboardTheme theme;
  final String contactName;
  final List<ChatMessage> initialMessages;

  @override
  State<ChatThreadScreen> createState() => _ChatThreadScreenState();
}

class _ChatThreadScreenState extends State<ChatThreadScreen> {
  late final List<ChatMessage> _messages;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List.of(widget.initialMessages);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, fromMe: true));
      _inputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
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
        title: Text(widget.contactName, style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: message.fromMe ? theme.accent : theme.surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        message.text,
                        style: AppTextStyles.body(
                          color: message.fromMe ? theme.onAccent : theme.onSurface,
                          size: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: PillTextField(
                      hint: 'Type a message',
                      controller: _inputController,
                      fillColor: theme.surface,
                      textColor: theme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: theme.accent, shape: BoxShape.circle),
                      child: Icon(Icons.send_rounded, color: theme.onAccent, size: 20),
                    ),
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
