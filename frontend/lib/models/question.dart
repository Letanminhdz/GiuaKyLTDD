class Question {
  final int id;
  final int questionGroupId;
  final int questionNumber;
  final String content;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String? passageText;
  final String? imageUrl;
  final int part; // Part 5, 6, 7
  final String skill; // "Phát âm & Trọng âm", "Từ vựng & Ngữ pháp", "Đọc hiểu"

  Question({
    required this.id,
    required this.questionGroupId,
    required this.questionNumber,
    required this.content,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    this.passageText,
    this.imageUrl,
    this.part = 5,
    this.skill = "Từ vựng & Ngữ pháp",
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      questionGroupId: json['questionGroupId'] ?? 0,
      questionNumber: json['questionNumber'] ?? 1,
      content: json['content'] ?? '',
      optionA: json['optionA'] ?? '',
      optionB: json['optionB'] ?? '',
      optionC: json['optionC'] ?? '',
      optionD: json['optionD'] ?? '',
      correctAnswer: json['correctAnswer'] ?? 'A',
      passageText: json['passageText'],
      imageUrl: json['imageUrl'],
      part: json['part'] ?? 5,
      skill: json['skill'] ?? "Từ vựng & Ngữ pháp",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionGroupId': questionGroupId,
      'questionNumber': questionNumber,
      'content': content,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'correctAnswer': correctAnswer,
      'passageText': passageText,
      'imageUrl': imageUrl,
      'part': part,
      'skill': skill,
    };
  }

  List<String> get options => [optionA, optionB, optionC, optionD];
}

