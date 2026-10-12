import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuestionNavSheet extends StatelessWidget {
  final int totalQuestions;
  final int currentIndex;
  final Map<int, String> answers;
  final Set<int> flaggedIndices;
  final Function(int) onSelectQuestion;

  const QuestionNavSheet({
    super.key,
    required this.totalQuestions,
    required this.currentIndex,
    required this.answers,
    required this.flaggedIndices,
    required this.onSelectQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final answeredCount = answers.length;
    final progress = totalQuestions > 0 ? (answeredCount / totalQuestions) : 0.0;
    final percentage = (progress * 100).round();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header & Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Danh sách câu hỏi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$answeredCount/$totalQuestions câu đã trả lời',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFEDECF2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                boxColor: AppColors.primarySoft,
                borderColor: const Color(0xFFD9D5FA),
                label: 'Đã trả lời',
              ),
              _buildLegendItem(
                boxColor: Colors.white,
                borderColor: AppColors.line,
                label: 'Chưa trả lời',
              ),
              _buildLegendItem(
                boxColor: AppColors.warning,
                borderColor: AppColors.warning,
                label: 'Đánh dấu',
                isCircle: true,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Number Grid
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: totalQuestions,
              itemBuilder: (context, index) {
                final isCurrent = index == currentIndex;
                final isAnswered = answers.containsKey(index) && answers[index]!.isNotEmpty;
                final isFlagged = flaggedIndices.contains(index);

                Color bgColor = Colors.white;
                Color textColor = const Color(0xFF737B8E);
                Color borderColor = AppColors.line;
                FontWeight fontWeight = FontWeight.w500;

                if (isCurrent) {
                  bgColor = AppColors.primary;
                  textColor = Colors.white;
                  borderColor = AppColors.primary;
                  fontWeight = FontWeight.w700;
                } else if (isAnswered) {
                  bgColor = AppColors.primarySoft;
                  textColor = AppColors.primary;
                  borderColor = const Color(0xFFD9D5FA);
                  fontWeight = FontWeight.w700;
                }

                return InkWell(
                  onTap: () {
                    onSelectQuestion(index);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: fontWeight,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (isFlagged)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 6,
                            height: 6,
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
          const SizedBox(height: 14),

          // Autosave label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 15,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                'Đã tự động lưu bài làm',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.success.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color boxColor,
    required Color borderColor,
    required String label,
    bool isCircle = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: boxColor,
            border: Border.all(color: borderColor),
            borderRadius: isCircle ? null : BorderRadius.circular(3),
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
