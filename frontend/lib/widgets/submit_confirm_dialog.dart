import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SubmitConfirmDialog extends StatelessWidget {
  final int answeredCount;
  final int unansweredCount;
  final int flaggedCount;
  final VoidCallback onContinueExam;
  final VoidCallback onSubmitNow;

  const SubmitConfirmDialog({
    super.key,
    required this.answeredCount,
    required this.unansweredCount,
    required this.flaggedCount,
    required this.onContinueExam,
    required this.onSubmitNow,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF3DF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),

            // Title
            const Text(
              'Xác nhận nộp bài?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),

            // Warning Description
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Bạn vẫn còn '),
                  TextSpan(
                    text: '$unansweredCount câu chưa trả lời',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const TextSpan(
                    text: '. Sau khi nộp, bạn sẽ không thể thay đổi đáp án.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3-Column Summary Box
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  _buildSummaryCol(answeredCount.toString(), 'Đã trả lời'),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.line,
                  ),
                  _buildSummaryCol(unansweredCount.toString(), 'Chưa trả lời'),
                  Container(
                    width: 1,
                    height: 32,
                    color: AppColors.line,
                  ),
                  _buildSummaryCol(flaggedCount.toString(), 'Đánh dấu'),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onContinueExam,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.line),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      foregroundColor: const Color(0xFF4E566B),
                    ),
                    child: const Text(
                      'Tiếp tục làm',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSubmitNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Nộp bài ngay',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCol(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

