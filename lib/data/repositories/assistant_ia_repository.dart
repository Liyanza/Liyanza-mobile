import '../datasources/assistant_ia_remote_datasource.dart';
import '../models/assistant_ia/assistant_ia_models.dart';

class AssistantIaRepository {
  final AssistantIaRemoteDatasource _remote;

  AssistantIaRepository(this._remote);

  Future<AiConversationModel> createConversation(String topic) => _remote.createConversation(topic);

  Future<SendMessageResult> sendMessage(String conversationId, String content) =>
      _remote.sendMessage(conversationId, content);

  Future<AiConversationModel> getConversation(String conversationId) =>
      _remote.getConversation(conversationId);
}