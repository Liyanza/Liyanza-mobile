// ===========================================================
// QUESTION (GET /questionnaires-simulation/questions)
// ===========================================================

class SimulationQuestionModel {
  final String id;
  final String label;
  final String fieldType;

  const SimulationQuestionModel({
    required this.id,
    required this.label,
    required this.fieldType,
  });

  factory SimulationQuestionModel.fromJson(Map<String, dynamic> json) => SimulationQuestionModel(
        id: json['id'] as String,
        label: json['label'] as String,
        fieldType: json['fieldType'] as String,
      );
}

// ===========================================================
// RÉPONSE ENVOYÉE (POST)
// ===========================================================

class SimulationAnswerInput {
  final String questionId;
  final String value;

  const SimulationAnswerInput({required this.questionId, required this.value});

  Map<String, dynamic> toJson() => {'questionId': questionId, 'value': value};
}

class SubmitSimulationRequest {
  final List<SimulationAnswerInput> reponses;
  const SubmitSimulationRequest(this.reponses);

  Map<String, dynamic> toJson() => {'reponses': reponses.map((r) => r.toJson()).toList()};
}

// ===========================================================
// RÉPONSE ENREGISTRÉE (dans le résultat / l'historique)
// ===========================================================

class SimulationAnswerModel {
  final String id;
  final String value;
  final SimulationQuestionModel question;

  const SimulationAnswerModel({required this.id, required this.value, required this.question});

  factory SimulationAnswerModel.fromJson(Map<String, dynamic> json) => SimulationAnswerModel(
        id: json['id'] as String,
        value: json['value'] as String,
        question: SimulationQuestionModel.fromJson(json['question'] as Map<String, dynamic>),
      );
}

// ===========================================================
// RÉSULTAT DE SIMULATION
// ===========================================================

class SimulationModel {
  final String id;
  final double estimatedBudget;
  final String expectedResults;
  final DateTime simulatedAt;
  final List<SimulationAnswerModel> answers;

  const SimulationModel({
    required this.id,
    required this.estimatedBudget,
    required this.expectedResults,
    required this.simulatedAt,
    required this.answers,
  });

  factory SimulationModel.fromJson(Map<String, dynamic> json) {
    final questionnaire = json['questionnaire'] as Map<String, dynamic>;
    final answers = (questionnaire['answers'] as List)
        .map((e) => SimulationAnswerModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return SimulationModel(
      id: json['id'] as String,
      // `estimatedBudget` est un Decimal Prisma (comme plannedBudget côté
      // campagnes, guide 2 étape 3) : même parade via toString()/num.parse.
      estimatedBudget: num.parse(json['estimatedBudget'].toString()).toDouble(),
      expectedResults: json['expectedResults'] as String,
      simulatedAt: DateTime.parse(json['simulatedAt'] as String),
      answers: answers,
    );
  }
}