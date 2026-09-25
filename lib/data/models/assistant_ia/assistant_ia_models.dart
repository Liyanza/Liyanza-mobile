// ===========================================================
// EXPÉDITEUR D'UN MESSAGE
// ===========================================================

// `sender` est une simple colonne String côté Prisma (pas d'enum en base),
// mais le backend n'écrit que 'USER' ou 'AI' (assistant-ia.service.ts) — on
// modélise quand même en enum côté Dart pour éviter les comparaisons de
// chaînes disséminées dans l'UI.
enum MessageSender { user, ai }

MessageSender messageSenderFromJson(String value) => switch (value) {
      'USER' => MessageSender.user,
      'AI' => MessageSender.ai,
      _ => throw FormatException('Expéditeur de message inconnu: $value'),
    };

// ===========================================================
// MESSAGE
// ===========================================================

class AiMessageModel {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime sentAt;
  final String conversationId;

  const AiMessageModel({
    required this.id,
    required this.content,
    required this.sender,
    required this.sentAt,
    required this.conversationId,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) => AiMessageModel(
        id: json['id'] as String,
        content: json['content'] as String,
        sender: messageSenderFromJson(json['sender'] as String),
        sentAt: DateTime.parse(json['sentAt'] as String),
        conversationId: json['conversationId'] as String,
      );
}

// ===========================================================
// CONVERSATION
// ===========================================================

class AiConversationModel {
  final String id;
  final DateTime startedAt;
  final String topic;
  final List<AiMessageModel> messages;

  const AiConversationModel({
    required this.id,
    required this.startedAt,
    required this.topic,
    this.messages = const [],
  });

  factory AiConversationModel.fromJson(Map<String, dynamic> json) => AiConversationModel(
        id: json['id'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        topic: json['topic'] as String,
        // `POST /conversations` renvoie la conversation SANS le champ
        // `messages` (create() sans include côté service) — contrairement à
        // `GET /conversations/:id` qui le peuple toujours. On tolère donc son
        // absence plutôt que de forcer un cast qui planterait à la création.
        messages: (json['messages'] as List?)
                ?.map((e) => AiMessageModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

// ===========================================================
// RÉPONSE DE POST /conversations/:id/messages
// ===========================================================

class SendMessageResult {
  final AiMessageModel userMessage;
  final AiMessageModel iaMessage;

  const SendMessageResult({required this.userMessage, required this.iaMessage});

  factory SendMessageResult.fromJson(Map<String, dynamic> json) => SendMessageResult(
        userMessage: AiMessageModel.fromJson(json['userMessage'] as Map<String, dynamic>),
        iaMessage: AiMessageModel.fromJson(json['iaMessage'] as Map<String, dynamic>),
      );
}