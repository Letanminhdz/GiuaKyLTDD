import 'question.dart';

class QuestionGroup {
  final int id;
  final int examId;
  final String passageText;
  final String? imageUrl;
  final List<Question> questions;

  QuestionGroup({
    required this.id,
    required this.examId,
    required this.passageText,
    this.imageUrl,
    this.questions = const [],
  });

  factory QuestionGroup.fromJson(Map<String, dynamic> json) {
    var rawQuestions = json['questions'] as List? ?? [];
    List<Question> parsedQuestions =
        rawQuestions.map((q) => Question.fromJson(q)).toList();

    return QuestionGroup(
      id: json['id'] ?? 0,
      examId: json['examId'] ?? 0,
      passageText: json['passageText'] ?? '',
      imageUrl: json['imageUrl'],
      questions: parsedQuestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'passageText': passageText,
      'imageUrl': imageUrl,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

