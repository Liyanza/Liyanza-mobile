import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_exceptions.dart';
import '../../core/providers/account_providers.dart';
import '../../core/providers/dashboard_providers.dart';
import '../../core/theme/kiyanza_colors.dart';
import '../../data/models/account/account_models.dart';

/// « il y a 5 min », « il y a 3 h », sinon « 12/10 à 09:30 ».
String relativeTime(DateTime date, DateTime now) {
  final diff = now.difference(date);
  if (diff.inMinutes < 1) return "à l'instant";
  if (diff.inMinutes < 60) return 'il y a ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'il y a ${diff.inHours} h';
  final d = date.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(d.day)}/${two(d.month)} à ${two(d.hour)}:${two(d.minute)}';
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  static const _pageSize = 20;

  final List<NotificationModel> _items = [];
  bool _unreadOnly = false;
  bool _loading = true;
  bool _loadingMore = false;
  int _page = 1;
  int _totalPages = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await ref
          .read(accountRemoteDatasourceProvider)
          .notifications(page: 1, limit: _pageSize, unreadOnly: _unreadOnly);
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(page.items);
        _page = page.page;
        _totalPages = page.totalPages;
      });
    } on AppException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    try {
      final page = await ref
          .read(accountRemoteDatasourceProvider)
          .notifications(page: _page + 1, limit: _pageSize, unreadOnly: _unreadOnly);
      if (!mounted) return;
      setState(() {
        _items.addAll(page.items);
        _page = page.page;
        _totalPages = page.totalPages;
      });
    } on AppException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  Future<void> _open(NotificationModel notification) async {
    if (!notification.isRead) {
      final index = _items.indexWhere((n) => n.id == notification.id);
      setState(() => _items[index] = notification.markedRead());
      try {
        await ref.read(accountRemoteDatasourceProvider).markNotificationRead(notification.id);
        ref.invalidate(homeDataProvider);
      } on AppException {
        // Sans réseau, la notification redeviendra non lue au prochain chargement.
      }
    }
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(relativeTime(notification.sentAt, DateTime.now()),
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
            const SizedBox(height: 12),
            Text(notification.message, style: const TextStyle(fontSize: 13.5, color: Color(0xFF374151), height: 1.45)),
          ],
        ),
      ),
    );
  }

  void _setFilter(bool unreadOnly) {
    if (unreadOnly == _unreadOnly) return;
    setState(() => _unreadOnly = unreadOnly);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.2)),
      ),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Retour',
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle),
                child: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF111827)),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    Widget chip(String label, bool selected, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.green : const Color(0xFFF3F4F6),
                border: selected ? null : Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.white : const Color(0xFF374151),
                ),
              ),
            ),
          ),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          chip('Toutes', !_unreadOnly, () => _setFilter(false)),
          chip('Non lues', _unreadOnly, () => _setFilter(true)),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.gray500)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Réessayer')),
          ],
        ),
      );
    }

    final now = DateTime.now();
    final hasMore = _page < _totalPages;
    return RefreshIndicator(
      onRefresh: _load,
      child: _items.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                const Icon(Icons.notifications_none, size: 40, color: Color(0xFF9CA3AF)),
                const SizedBox(height: 12),
                Text(
                  _unreadOnly ? 'Aucune notification non lue.' : 'Aucune notification pour le moment.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _items.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _items.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: _loadingMore
                          ? const CircularProgressIndicator()
                          : TextButton(onPressed: _loadMore, child: const Text('Voir plus')),
                    ),
                  );
                }
                final notification = _items[index];
                final group = notificationGroup(notification.sentAt, now);
                final showGroup = index == 0 || notificationGroup(_items[index - 1].sentAt, now) != group;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showGroup)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          group,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    _NotificationTile(
                      notification: notification,
                      now: now,
                      onTap: () => _open(notification),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final DateTime now;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.now, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (notification.kind) {
      NotificationKind.success => (Icons.check_circle_outline, const Color(0xFF16A34A)),
      NotificationKind.warning => (Icons.warning_amber_rounded, const Color(0xFFEA580C)),
      NotificationKind.error => (Icons.error_outline, const Color(0xFFDC2626)),
      NotificationKind.info => (Icons.notifications_none, const Color(0xFF2563EB)),
    };

    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? null : const Color(0xFFF0FDF4),
          border: const Border(bottom: BorderSide(color: Color(0xFFF9FAFB), width: 1.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.only(left: 6, top: 4),
                          decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280), height: 1.35),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    relativeTime(notification.sentAt, now),
                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF)),
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
