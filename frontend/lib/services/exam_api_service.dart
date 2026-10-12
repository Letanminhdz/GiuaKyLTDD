import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exam.dart';
import '../models/exam_result.dart';
import '../models/question.dart';
import 'mock_data.dart';

class ExamApiService {
  // Singleton pattern
  static final ExamApiService _instance = ExamApiService._internal();
  factory ExamApiService() => _instance;
  ExamApiService._internal();

  // Cấu hình URL kết nối tới ASP.NET Core Backend
  // 10.0.2.2 cho Android Emulator, localhost cho Chrome/Windows
  String baseUrl = 'http://localhost:5000';
  bool useMockAlways = false;

  /// Lấy danh sách đề thi (khớp với Controller Index / GetExams của C#)
  Future<List<Exam>> getExams() async {
    if (useMockAlways) {
      return MockData.getMockExams();
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/services/app/Exam/GetExams'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data['result'] ?? data) as List;
        return list.map((item) => Exam.fromJson(item)).toList();
      }
    } catch (_) {
      // Khi Backend chưa bật hoặc không kết nối được -> dùng dữ liệu chuẩn Figma
    }

    return MockData.getMockExams();
  }

  /// Lấy chi tiết đề thi kèm câu hỏi
  Future<Exam> getExamDetail(int examId) async {
    if (useMockAlways) {
      return MockData.getMockExams().firstWhere(
        (e) => e.id == examId,
        orElse: () => MockData.getMockExams().first,
      );
    }

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/services/app/Exam/GetExamDetail?examId=$examId'))
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final examObj = Exam.fromJson(data['result'] ?? data);
        if (examObj.flattenedQuestions.isNotEmpty) {
          return examObj;
        }
      }
    } catch (_) {
      // Fallback
    }

    return MockData.getMockExams().firstWhere(
      (e) => e.id == examId,
      orElse: () => MockData.getMockExams().first,
    );
  }

  /// Nộp bài thi và chấm điểm
  Future<ExamResult> submitExam({
    required int examId,
    required String examTitle,
    required List<Question> questions,
    required Map<int, String> userAnswers,
    required Duration timeSpent,
  }) async {
    // Chấm điểm cục bộ tính toán chính xác
    final localResult = ExamResult.calculate(
      examId: examId,
      examTitle: examTitle,
      questions: questions,
      userAnswers: userAnswers,
      timeSpent: timeSpent,
    );

    try {
      // Gửi kết quả lên C# Backend nếu có
      await http.post(
        Uri.parse('$baseUrl/api/services/app/Exam/SubmitExam'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'examId': examId,
          'score': localResult.score,
          'correctCount': localResult.correctCount,
          'wrongCount': localResult.wrongCount,
          'userAnswers': userAnswers,
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {
      // Không chặn người dùng nếu mạng hoặc backend tắt
    }

    return localResult;
  }
}

