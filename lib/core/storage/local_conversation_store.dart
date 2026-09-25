import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalConversationEntry {
  final String id;
  final String topic;
  final DateTime startedAt;

  const LocalConversationEntry({required this.id, required this.topic, required this.startedAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'topic': topic,
        'startedAt': startedAt.toIso8601String(),
      };

  factory LocalConversationEntry.fromJson(Map<String, dynamic> json) => LocalConversationEntry(
        id: json['id'] as String,
        topic: json['topic'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
      );
}

class LocalConversationStore {
  // Réutilise flutter_secure_storage (déjà une dépendance, guide auth étape
  // 1) plutôt que d'introduire shared_preferences pour un seul écran.
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _key = 'kiyanza_ia_local_conversations';
  static const _maxEntries = 30;

  Future<List<LocalConversationEntry>> list() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => LocalConversationEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt)); // plus récent en premier
  }

  Future<void> add(LocalConversationEntry entry) async {
    final current = await list();
    // Pas de doublon si l'entrée existe déjà (rechargement d'une conversation
    // existante plutôt que création).
    final updated = [entry, ...current.where((e) => e.id != entry.id)];
    final capped = updated.take(_maxEntries).toList();
    await _storage.write(key: _key, value: jsonEncode(capped.map((e) => e.toJson()).toList()));
  }
}