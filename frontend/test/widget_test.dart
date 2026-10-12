import 'package:flutter_test/flutter_test.dart';
import 'package:giuaki_mobile/main.dart';
import 'package:giuaki_mobile/services/exam_api_service.dart';

void main() {
  testWidgets('EduTest App smoke test', (WidgetTester tester) async {
    // Enable MockData always for tests so no network requests are attempted
    ExamApiService().useMockAlways = true;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const EduTestApp());
    await tester.pumpAndSettle();

    // Verify that the welcome banner and exam header are found.
    expect(find.text('Chào buổi sáng'), findsOneWidget);
    expect(find.text('Đề thi của bạn'), findsOneWidget);
    expect(find.text('Kiểm tra cuối kỳ — Tiếng Anh 12'), findsOneWidget);
  });
}
