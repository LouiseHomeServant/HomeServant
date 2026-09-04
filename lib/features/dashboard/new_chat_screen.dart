import 'package:flutter/material.dart';
import '../../core/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/dashboard_theme.dart';
import 'models/chat_user.dart';

/// What [NewChatScreen] hands back to [MessagesScreen] — either a single
/// contact (1:1 chat) or several people plus a chosen name (group chat).
class NewChatResult {
  const NewChatResult({required this.name, required this.participants, required this.isGroup});

  final String name;
  final List<String> participants;
  final bool isGroup;
}

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key, required this.theme});

  final DashboardTheme theme;

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _selected = {};

  List<ChatUser> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return mockChatUsers;
    return mockChatUsers.where((u) => u.name.toLowerCase().contains(q)).toList();
  }

  void _toggle(String name) {
    setState(() {
      if (!_selected.remove(name)) _selected.add(name);
    });
  }

  Future<void> _confirm() async {
    if (_selected.isEmpty) return;
    if (_selected.length == 1) {
      Navigator.of(
        context,
      ).pop(NewChatResult(name: _selected.first, participants: _selected.toList(), isGroup: false));
      return;
    }
    final groupName = await _promptGroupName();
    if (groupName == null || !mounted) return;
    final name = groupName.trim().isEmpty ? _selected.join(', ') : groupName.trim();
    Navigator.of(context).pop(NewChatResult(name: name, participants: _selected.toList(), isGroup: true));
  }

  Future<String?> _promptGroupName() {
    final controller = TextEditingController();
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name this group', style: AppTextStyles.heading(color: AppColors.navy, size: 18)),
                const SizedBox(height: 6),
                Text(
                  '${_selected.length} people selected',
                  style: AppTextStyles.body(color: AppColors.hintGrey, size: 13),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: AppTextStyles.body(color: AppColors.navy),
                  decoration: InputDecoration(
                    hintText: _selected.join(', '),
                    filled: true,
                    fillColor: AppColors.navy.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: () => Navigator.of(context).pop(controller.text),
                    child: Text('Create Group', style: AppTextStyles.button(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: Text('New Message', style: AppTextStyles.heading(color: theme.foreground, size: 18)),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 640,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: theme.onSurface.withValues(alpha: 0.5)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          style: AppTextStyles.body(color: theme.onSurface),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Search people',
                            hintStyle: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.4)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selected.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_selected.length} selected · pick more for a group chat',
                      style: AppTextStyles.body(color: theme.foreground.withValues(alpha: 0.6), size: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = _filtered[index];
                    final selected = _selected.contains(user.name);
                    return GestureDetector(
                      onTap: () => _toggle(user.name),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: selected ? Border.all(color: theme.accent, width: 1.6) : null,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: theme.accent.withValues(alpha: 0.25),
                              child: Icon(Icons.person, color: theme.accent),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: AppTextStyles.body(color: theme.onSurface, size: 14, weight: FontWeight.w700),
                                  ),
                                  Text(
                                    user.subtitle,
                                    style: AppTextStyles.body(color: theme.onSurface.withValues(alpha: 0.55), size: 12),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                              color: selected ? theme.accent : theme.onSurface.withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: _selected.isEmpty ? null : _confirm,
                    child: Text(
                      _selected.length > 1 ? 'Create Group (${_selected.length})' : 'Start Chat',
                      style: AppTextStyles.button(color: theme.onAccent),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
