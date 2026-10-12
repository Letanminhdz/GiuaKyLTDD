import 'question.dart';
import 'question_group.dart';

class Exam {
  final int id;
  final String name;
  final int durationInMinutes;
  final int totalQuestions;
  final String subject;
  final String code;
  final String date;
  final String status;
  final String color;
  final List<QuestionGroup> questionGroups;
  final List<Question> flattenedQuestions;

  Exam({
    required this.id,
    required this.name,
    this.durationInMinutes = 75,
    this.totalQuestions = 40,
    this.subject = "Tiếng Anh",
    this.code = "TA12-CK1",
    this.date = "18/06/2025",
    this.status = "Đã xuất bản",
    this.color = "violet",
    this.questionGroups = const [],
    List<Question>? questions,
  }) : flattenedQuestions = questions ??
            questionGroups.expand((group) => group.questions).toList();

  factory Exam.fromJson(Map<String, dynamic> json) {
    var rawGroups = json['questionGroups'] as List? ?? [];
    List<QuestionGroup> parsedGroups =
        rawGroups.map((g) => QuestionGroup.fromJson(g)).toList();

    List<Question>? flatQuestions;
    if (json['questions'] != null && (json['questions'] as List).isNotEmpty) {
      var rawQuestions = json['questions'] as List;
      flatQuestions = rawQuestions.map((q) => Question.fromJson(q)).toList();
    }

    return Exam(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      durationInMinutes: json['durationInMinutes'] ?? 75,
      totalQuestions: json['totalQuestions'] ?? 40,
      subject: json['subject'] ?? "Tiếng Anh",
      code: json['code'] ?? "TA-01",
      date: json['date'] ?? "18/06/2025",
      status: json['status'] ?? "Đã xuất bản",
      color: json['color'] ?? "violet",
      questionGroups: parsedGroups,
      questions: flatQuestions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'durationInMinutes': durationInMinutes,
      'totalQuestions': totalQuestions,
      'subject': subject,
      'code': code,
      'date': date,
      'status': status,
      'color': color,
      'questionGroups': questionGroups.map((g) => g.toJson()).toList(),
    };
  }
}

