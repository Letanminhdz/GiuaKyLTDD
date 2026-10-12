import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../services/exam_api_service.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/option_card.dart';
import '../widgets/question_nav_sheet.dart';
import '../widgets/submit_confirm_dialog.dart';
import 'result_screen.dart';

class ExamScreen extends StatefulWidget {
  final Exam exam;

  const ExamScreen({
    super.key,
    required this.exam,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final ExamApiService _apiService = ExamApiService();
  late List<Question> _questions;
  int _currentIndex = 0;

  // Trạng thái bài làm:
  // Map index câu hỏi (0..N-1) -> đáp án chọn ('A', 'B', 'C', 'D')
  final Map<int, String> _userAnswers = {};
  // Tập hợp các câu được đánh dấu cờ (flag)
  final Set<int> _flaggedIndices = {};

  // Quản lý đếm ngược thời gian thực
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _questions = widget.exam.flattenedQuestions;
    if (_questions.isEmpty) {
      // Fallback nếu rỗng từ questionGroups
      _questions = widget.exam.questionGroups
          .expand((g) => g.questions)
          .toList();
    }
    if (_questions.isEmpty) {
      // Fallback từ đề thi chuẩn nếu chưa tải được
      _questions = MockData.getMockExams().first.flattenedQuestions;
    }

    _totalSeconds = widget.exam.durationInMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _onTimeExpired();
      }
    });
  }

  void _onTimeExpired() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hết giờ làm bài! Hệ thống đang tự động thu bài...'),
        backgroundColor: AppColors.danger,
        duration: Duration(seconds: 2),
      ),
    );
    _performSubmit();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = remainingSecs.toString().padLeft(2, '0');
    return '$mStr:$sStr';
  }

  void _selectAnswer(String optionLetter) {
    setState(() {
      if (_userAnswers[_currentIndex] == optionLetter) {
        // Cho phép huỷ chọn nếu bấm lại
        _userAnswers.remove(_currentIndex);
      } else {
        _userAnswers[_currentIndex] = optionLetter;
      }
    });
  }

  void _toggleFlag() {
    setState(() {
      if (_flaggedIndices.contains(_currentIndex)) {
        _flaggedIndices.remove(_currentIndex);
      } else {
        _flaggedIndices.add(_currentIndex);
      }
    });
  }

  void _showQuestionMap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuestionNavSheet(
        totalQuestions: _questions.length,
        currentIndex: _currentIndex,
        answers: _userAnswers,
        flaggedIndices: _flaggedIndices,
        onSelectQuestion: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  void _showSubmitDialog() {
    final unanswered = _questions.length - _userAnswers.length;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => SubmitConfirmDialog(
        answeredCount: _userAnswers.length,
        unansweredCount: unanswered,
        flaggedCount: _flaggedIndices.length,
        onContinueExam: () => Navigator.of(context).pop(),
        onSubmitNow: () {
          Navigator.of(context).pop();
          _performSubmit();
        },
      ),
    );
  }

  Future<void> _performSubmit() async {
    _timer?.cancel();

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    final timeSpent = Duration(seconds: _totalSeconds - _remainingSeconds);

    final result = await _apiService.submitExam(
      examId: widget.exam.id,
      examTitle: widget.exam.name,
      questions: _questions,
      userAnswers: _userAnswers,
      timeSpent: timeSpent,
    );

    if (mounted) {
      Navigator.of(context).pop(); // Đóng loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: result,
            exam: widget.exam,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.exam.name)),
        body: const Center(child: Text('Không có câu hỏi nào trong đề thi này.')),
      );
    }

    final currentQuestion = _questions[_currentIndex];
    final isFlagged = _flaggedIndices.contains(_currentIndex);
    final selectedOption = _userAnswers[_currentIndex];
    final isTimerLow = _remainingSeconds < 300; // Dưới 5 phút

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Topbar with Timer & Submit
            _buildTopBar(isTimerLow, currentQuestion),

            // Horizontal Question Map strip
            _buildQuickQuestionStrip(),

            // Question Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Header Card
                    _buildQuestionCard(currentQuestion, isFlagged, selectedOption),
                    const SizedBox(height: 16),

                    // Navigation Prev / Next
                    _buildNavButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isTimerLow, Question currentQuestion) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exam info
          Expanded(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: AppColors.muted,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.exam.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        'Phần Part ${currentQuestion.part} · ${currentQuestion.skill}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Timer Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isTimerLow
                  ? const Color(0xFFFFF1F2)
                  : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isTimerLow
                    ? const Color(0xFFF5DFE1)
                    : const Color(0xFFFED7AA),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.alarm,
                  size: 15,
                  color: isTimerLow
                      ? AppColors.danger
                      : const Color(0xFFA75B16),
                ),
                const SizedBox(width: 5),
                Text(
                  _formatTimer(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: isTimerLow
                        ? AppColors.danger
                        : const Color(0xFFA75B16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Submit Button
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: _showSubmitDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF202943),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Nộp bài',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestionStrip() {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          // Grid Sheet button
          InkWell(
            onTap: _showQuestionMap,
            child: Container(
              margin: const EdgeInsets.only(left: 12, right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),

          // Horizontal Number list
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: _questions.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final isCurrent = index == _currentIndex;
                final isAnswered = _userAnswers.containsKey(index);
                final isFlagged = _flaggedIndices.contains(index);

                Color bg = Colors.white;
                Color text = const Color(0xFF737B8E);
                Color border = AppColors.line;

                if (isCurrent) {
                  bg = AppColors.primary;
                  text = Colors.white;
                  border = AppColors.primary;
                } else if (isAnswered) {
                  bg = AppColors.primarySoft;
                  text = AppColors.primary;
                  border = const Color(0xFFD9D5FA);
                }

                return InkWell(
                  onTap: () => setState(() => _currentIndex = index),
                  borderRadius: BorderRadius.circular(7),
                  child: Stack(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: border),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isCurrent || isAnswered
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: text,
                          ),
                        ),
                      ),
                      if (isFlagged)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.warning,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(
      Question question, bool isFlagged, String? selectedOption) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Index & Flag button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CÂU ${_currentIndex + 1} / ${_questions.length}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
              ),
              InkWell(
                onTap: _toggleFlag,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isFlagged ? Icons.flag : Icons.flag_outlined,
                        size: 15,
                        color: isFlagged
                            ? AppColors.warning
                            : AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isFlagged ? 'Đã đánh dấu' : 'Đánh dấu',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isFlagged
                              ? AppColors.warning
                              : AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Reading Passage (Part 6 & Part 7)
          if (question.passageText != null &&
              question.passageText!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFBFE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8E8EE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.article_outlined,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'ĐOẠN VĂN THAM KHẢO (Part ${question.part})',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.passageText!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF333B4F),
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Image (if any)
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                question.imageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 120,
                  color: const Color(0xFFEDEDF3),
                  alignment: Alignment.center,
                  child: const Text('Hình ảnh đề thi minh họa',
                      style: TextStyle(color: AppColors.muted)),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Question Content
          Text(
            question.content.replaceAll(RegExp(r'\[BLANK(?:\s+\d+)?\]', caseSensitive: false), '________'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),

          // 4 Options A, B, C, D
          OptionCard(
            letter: 'A',
            text: question.optionA,
            isSelected: selectedOption == 'A',
            onTap: () => _selectAnswer('A'),
          ),
          OptionCard(
            letter: 'B',
            text: question.optionB,
            isSelected: selectedOption == 'B',
            onTap: () => _selectAnswer('B'),
          ),
          OptionCard(
            letter: 'C',
            text: question.optionC,
            isSelected: selectedOption == 'C',
            onTap: () => _selectAnswer('C'),
          ),
          OptionCard(
            letter: 'D',
            text: question.optionD,
            isSelected: selectedOption == 'D',
            onTap: () => _selectAnswer('D'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButtons() {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _questions.length - 1;

    return Row(
      children: [
        // Previous question
        Expanded(
          child: OutlinedButton(
            onPressed: isFirst
                ? null
                : () => setState(() => _currentIndex--),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(
                color: isFirst ? AppColors.line : const Color(0xFFD4D8E2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: const Color(0xFF4E566B),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.arrow_back_ios_new, size: 14),
                SizedBox(width: 6),
                Text(
                  'Câu trước',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Next or Submit
        Expanded(
          child: ElevatedButton(
            onPressed: isLast
                ? _showSubmitDialog
                : () => setState(() => _currentIndex++),
            style: ElevatedButton.styleFrom(
              backgroundColor: isLast ? const Color(0xFF202943) : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLast ? 'Nộp bài thi' : 'Câu tiếp theo',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isLast ? Icons.check_circle_outline : Icons.arrow_forward_ios,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
