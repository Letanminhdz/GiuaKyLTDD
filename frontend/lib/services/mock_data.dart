import '../models/exam.dart';
import '../models/question.dart';
import '../models/question_group.dart';

class MockData {
  static const String sampleImage =
      'https://images.unsplash.com/photo-1785230995217-2bd87664791e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080';

  static List<Exam> getMockExams() {
    return [
      Exam(
        id: 1,
        name: 'Kiểm tra cuối kỳ — Tiếng Anh 12',
        subject: 'Tiếng Anh',
        code: 'TA12-CK1',
        durationInMinutes: 45,
        totalQuestions: 40,
        date: '18/06/2025',
        status: 'Đang mở',
        color: 'violet',
        questionGroups: _getExam1Groups(),
      ),
      Exam(
        id: 2,
        name: 'Khảo sát chất lượng Toán 11',
        subject: 'Toán học',
        code: 'TO11-KS2',
        durationInMinutes: 60,
        totalQuestions: 35,
        date: '20/06/2025',
        status: 'Sắp diễn ra',
        color: 'blue',
        questionGroups: _getExam2Groups(),
      ),
      Exam(
        id: 3,
        name: 'Ôn tập chương III — Vật lý 10',
        subject: 'Vật lý',
        code: 'VL10-C03',
        durationInMinutes: 30,
        totalQuestions: 25,
        date: '22/06/2025',
        status: 'Bản nháp',
        color: 'amber',
        questionGroups: _getExam3Groups(),
      ),
    ];
  }

  static List<QuestionGroup> _getExam1Groups() {
    List<Question> questions = [];

    // Part 5 Questions (Câu 1 - 25: Ngữ pháp, từ vựng, phát âm độc lập)
    questions.add(Question(
      id: 1,
      questionGroupId: 1,
      questionNumber: 1,
      content:
          'Choose the word whose underlined part is pronounced differently from the others.',
      optionA: 'climate',
      optionB: 'village',
      optionC: 'wildlife',
      optionD: 'invite',
      correctAnswer: 'B',
      part: 5,
      skill: 'Phát âm & Trọng âm',
    ));

    questions.add(Question(
      id: 2,
      questionGroupId: 1,
      questionNumber: 2,
      content:
          'The city has made significant progress in reducing air pollution, _____ more green spaces have been created.',
      optionA: 'because',
      optionB: 'although',
      optionC: 'so',
      optionD: 'unless',
      correctAnswer: 'A',
      part: 5,
      skill: 'Từ vựng & Ngữ pháp',
    ));

    questions.add(Question(
      id: 3,
      questionGroupId: 1,
      questionNumber: 3,
      content:
          'Ms. Durkin asked for volunteers to help -------- with the employee fitness program.',
      optionA: 'she',
      optionB: 'her',
      optionC: 'hers',
      optionD: 'herself',
      correctAnswer: 'B',
      part: 5,
      skill: 'Từ vựng & Ngữ pháp',
    ));

    questions.add(Question(
      id: 4,
      questionGroupId: 1,
      questionNumber: 4,
      content:
          'The new software will allow employees to work more -------- from any remote location.',
      optionA: 'efficient',
      optionB: 'efficiency',
      optionC: 'efficiently',
      optionD: 'more efficient',
      correctAnswer: 'C',
      part: 5,
      skill: 'Từ vựng & Ngữ pháp',
    ));

    questions.add(Question(
      id: 5,
      questionGroupId: 1,
      questionNumber: 5,
      content:
          'Look at the image and choose the sentence that best describes it.',
      imageUrl: sampleImage,
      optionA: 'The city is surrounded by mountains.',
      optionB: 'A modern skyscraper rises above the urban area.',
      optionC: 'The streets are completely empty.',
      optionD: 'All buildings have traditional architecture.',
      correctAnswer: 'B',
      part: 5,
      skill: 'Đọc hiểu',
    ));

    // Thêm các câu hỏi Part 5 sinh động theo chuẩn TOEIC
    for (int i = 6; i <= 25; i++) {
      questions.add(Question(
        id: i,
        questionGroupId: 1,
        questionNumber: i,
        content: _getPart5Content(i),
        optionA: _getPart5Option(i, 0),
        optionB: _getPart5Option(i, 1),
        optionC: _getPart5Option(i, 2),
        optionD: _getPart5Option(i, 3),
        correctAnswer: ['A', 'B', 'C', 'D'][i % 4],
        part: 5,
        skill: i % 3 == 0
            ? 'Phát âm & Trọng âm'
            : (i % 3 == 1 ? 'Từ vựng & Ngữ pháp' : 'Đọc hiểu'),
      ));
    }

    // Part 6 Group (Câu 26 - 32: Điền vào bài đọc)
    const String passagePart6 =
        '''With Global Strength Gym's 30-day trial period, you get the opportunity to try out our classes, equipment, and facilities. It's completely risk-free! To sign up, we require your contact information and payment details, but you will only be charged if you are a member for [131] 30 days. If you decide within this time that you no longer want to be a member of Global Strength, simply visit our Web site at www.gsgym.com. On the Membership page, elect to [132] your membership and enter the necessary information. It's that easy!''';

    List<Question> part6Questions = [
      Question(
        id: 26,
        questionGroupId: 2,
        questionNumber: 26,
        content:
            'Questions 26-28 refer to the gym advertisement above. Choose the best word for blank [131].',
        passageText: passagePart6,
        optionA: 'not even',
        optionB: 'almost',
        optionC: 'over',
        optionD: 'less than',
        correctAnswer: 'C',
        part: 6,
        skill: 'Đọc hiểu',
      ),
      Question(
        id: 27,
        questionGroupId: 2,
        questionNumber: 27,
        content:
            'Choose the best word for blank [132] in the gym advertisement.',
        passageText: passagePart6,
        optionA: 'extend',
        optionB: 'renew',
        optionC: 'cancel',
        optionD: 'initiate',
        correctAnswer: 'C',
        part: 6,
        skill: 'Từ vựng & Ngữ pháp',
      ),
      Question(
        id: 28,
        questionGroupId: 2,
        questionNumber: 28,
        content:
            'What is stated about the trial period at Global Strength Gym?',
        passageText: passagePart6,
        optionA: 'It requires a non-refundable deposit.',
        optionB: 'It includes access to all equipment and classes.',
        optionC: 'It must be activated in person at the facility.',
        optionD: 'It is limited to students only.',
        correctAnswer: 'B',
        part: 6,
        skill: 'Đọc hiểu',
      ),
    ];

    // Thêm câu 29 - 32 cho Part 6
    for (int i = 29; i <= 32; i++) {
      part6Questions.add(Question(
        id: i,
        questionGroupId: 2,
        questionNumber: i,
        content: 'Select the best phrase to complete blank [$i] in the text.',
        passageText: passagePart6,
        optionA: 'Throughout the trial period',
        optionB: 'In spite of previous notice',
        optionC: 'As soon as registration completes',
        optionD: 'Under the standard conditions',
        correctAnswer: ['A', 'B', 'C', 'D'][i % 4],
        part: 6,
        skill: 'Từ vựng & Ngữ pháp',
      ));
    }

    // Part 7 Group (Câu 33 - 40: Bài đọc hiểu chuyên sâu)
    const String passagePart7 =
        '''Modern cities are changing rapidly. As urban populations grow, municipal planners and international architects are collaborating to establish smarter, greener, and more sustainable infrastructures for future generations. Recent investments in high-speed electric transit and solar-powered civic centers have drastically reduced carbon footprints across metropolitan districts, establishing a gold standard for environmental resilience.''';

    List<Question> part7Questions = [
      Question(
        id: 33,
        questionGroupId: 3,
        questionNumber: 33,
        content: 'What is the main idea of the passage above?',
        passageText: passagePart7,
        imageUrl: sampleImage,
        optionA: 'Urban life is always stressful.',
        optionB: 'Cities are finding sustainable ways to grow.',
        optionC: 'Public transport is too expensive.',
        optionD: 'People prefer living in rural areas.',
        correctAnswer: 'B',
        part: 7,
        skill: 'Đọc hiểu',
      ),
      Question(
        id: 34,
        questionGroupId: 3,
        questionNumber: 34,
        content: 'The word "sustainable" is closest in meaning to _____.',
        passageText: passagePart7,
        optionA: 'temporary',
        optionB: 'expensive',
        optionC: 'maintainable',
        optionD: 'traditional',
        correctAnswer: 'C',
        part: 7,
        skill: 'Từ vựng & Ngữ pháp',
      ),
    ];

    for (int i = 35; i <= 40; i++) {
      part7Questions.add(Question(
        id: i,
        questionGroupId: 3,
        questionNumber: i,
        content:
            'According to the passage, what has contributed to lowering emissions in question $i?',
        passageText: passagePart7,
        optionA: 'High-speed electric transit and solar power.',
        optionB: 'Strict regulations on all vehicle owners.',
        optionC: 'Relocating factories away from rural communities.',
        optionD: 'Shutting down older industrial zones.',
        correctAnswer: ['B', 'A', 'C', 'D'][(i - 35) % 4],
        part: 7,
        skill: 'Đọc hiểu',
      ));
    }

    return [
      QuestionGroup(
        id: 1,
        examId: 1,
        passageText: 'Part 5: Incomplete Sentences',
        questions: questions,
      ),
      QuestionGroup(
        id: 2,
        examId: 1,
        passageText: passagePart6,
        questions: part6Questions,
      ),
      QuestionGroup(
        id: 3,
        examId: 1,
        passageText: passagePart7,
        imageUrl: sampleImage,
        questions: part7Questions,
      ),
    ];
  }

  static String _getPart5Content(int i) {
    switch (i % 6) {
      case 0:
        return 'The marketing department will release the quarterly report as soon as all survey figures are -------- verified.';
      case 1:
        return 'All visitors are requested to check in with security and obtain an identification badge before -------- the laboratory.';
      case 2:
        return 'The keynote speaker delivered an -------- speech on advancements in renewable energy storage technologies.';
      case 3:
        return 'Customer feedback indicates that the upgraded interface is substantially more -------- to navigate.';
      case 4:
        return 'Applicants must submit their completed portfolios -------- Friday at five o’clock to be considered.';
      default:
        return 'Neither the director -------- the committee members expressed reservations concerning the proposed budget.';
    }
  }

  static String _getPart5Option(int i, int optIndex) {
    final matrix = [
      ['thorough', 'thoroughly', 'thoroughness', 'more thorough'],
      ['enter', 'entering', 'entered', 'to enter'],
      ['inspiring', 'inspired', 'inspiration', 'inspire'],
      ['convenient', 'convenience', 'conveniently', 'inconvenient'],
      ['before', 'until', 'since', 'during'],
      ['nor', 'or', 'and', 'either'],
    ];
    return matrix[i % 6][optIndex];
  }

  static List<QuestionGroup> _getExam2Groups() {
    List<Question> questions = [];
    for (int i = 1; i <= 35; i++) {
      questions.add(Question(
        id: 100 + i,
        questionGroupId: 10,
        questionNumber: i,
        content: 'Cho hàm số f(x) liên tục trên R. Tính giới hạn lim f(x) khi x tiến tới $i.',
        optionA: 'x = $i',
        optionB: 'x = 0',
        optionC: 'x = -${i * 2}',
        optionD: 'Không tồn tại',
        correctAnswer: 'A',
        skill: 'Đại số & Giải tích',
      ));
    }
    return [
      QuestionGroup(
        id: 10,
        examId: 2,
        passageText: 'Phần thi Trắc nghiệm Toán 11',
        questions: questions,
      )
    ];
  }

  static List<QuestionGroup> _getExam3Groups() {
    List<Question> questions = [];
    for (int i = 1; i <= 25; i++) {
      questions.add(Question(
        id: 200 + i,
        questionGroupId: 20,
        questionNumber: i,
        content: 'Một vật có khối lượng m = ${i * 2} kg chuyển động với gia tốc a = 2 m/s². Tính lực tác dụng F.',
        optionA: '${i * 4} N',
        optionB: '${i * 2} N',
        optionC: '$i N',
        optionD: '${i * 8} N',
        correctAnswer: 'A',
        skill: 'Động lực học chất điểm',
      ));
    }
    return [
      QuestionGroup(
        id: 20,
        examId: 3,
        passageText: 'Phần thi Ôn tập Vật lý 10',
        questions: questions,
      )
    ];
  }
}
