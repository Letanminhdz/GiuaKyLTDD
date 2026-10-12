#pragma warning disable 1591
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using Abp.Application.Services;
using Abp.Application.Services.Dto;
using Abp.Domain.Repositories;
using Abp.UI;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using Microsoft.EntityFrameworkCore;

namespace GiuaKi.Exams
{
    public class ExamDto : EntityDto<int>
    {
        public string Name { get; set; }
        public int DurationInMinutes { get; set; }
        public int TotalQuestions { get; set; }
    }

    public class QuestionDetailDto : EntityDto<int>
    {
        public int QuestionGroupId { get; set; }
        public int QuestionNumber { get; set; }
        public string Content { get; set; }
        public string OptionA { get; set; }
        public string OptionB { get; set; }
        public string OptionC { get; set; }
        public string OptionD { get; set; }
        public string CorrectAnswer { get; set; }
        public string PassageText { get; set; }
    }

    public class ExamWithQuestionsDto : ExamDto
    {
        public List<QuestionDetailDto> Questions { get; set; } = new List<QuestionDetailDto>();
    }

    public class UpdateQuestionInput : EntityDto<int>
    {
        public string Content { get; set; }
        public string OptionA { get; set; }
        public string OptionB { get; set; }
        public string OptionC { get; set; }
        public string OptionD { get; set; }
        public string CorrectAnswer { get; set; }
        public string PassageText { get; set; }
    }

    public interface IExamAppService : IApplicationService
    {
        Task ImportExamFromWordAsync(byte[] fileBytes);
        Task<List<ExamDto>> GetExamsAsync();
        Task<ExamWithQuestionsDto> GetExamDetailAsync(int examId);
        Task UpdateQuestionAsync(UpdateQuestionInput input);
        Task UpdateExamInfoAsync(int id, string name, int durationInMinutes);
        Task DeleteExamAsync(int examId);
    }

    public class ExamAppService : ApplicationService, IExamAppService
    {
        private readonly IRepository<Exam> _examRepository;
        private readonly IRepository<QuestionGroup> _questionGroupRepository;
        private readonly IRepository<Question> _questionRepository;

        public ExamAppService(
            IRepository<Exam> examRepository,
            IRepository<QuestionGroup> questionGroupRepository,
            IRepository<Question> questionRepository)
        {
            _examRepository = examRepository;
            _questionGroupRepository = questionGroupRepository;
            _questionRepository = questionRepository;
        }

        public async Task<List<ExamDto>> GetExamsAsync()
        {
            var exams = await _examRepository.GetAllListAsync();
            return exams.Select(e => new ExamDto
            {
                Id = e.Id,
                Name = e.Name,
                DurationInMinutes = e.DurationInMinutes,
                TotalQuestions = e.TotalQuestions
            }).ToList();
        }

        public async Task<ExamWithQuestionsDto> GetExamDetailAsync(int examId)
        {
            var exam = await _examRepository.GetAsync(examId);
            var groups = await _questionGroupRepository.GetAllListAsync(g => g.ExamId == examId);
            var groupIds = groups.Select(g => g.Id).ToList();
            var questions = await _questionRepository.GetAllListAsync(q => groupIds.Contains(q.QuestionGroupId));

            var groupDict = groups.ToDictionary(g => g.Id, g => g.PassageText ?? "");

            var result = new ExamWithQuestionsDto
            {
                Id = exam.Id,
                Name = exam.Name,
                DurationInMinutes = exam.DurationInMinutes,
                TotalQuestions = exam.TotalQuestions,
                Questions = questions.OrderBy(q => q.QuestionNumber).Select(q => new QuestionDetailDto
                {
                    Id = q.Id,
                    QuestionGroupId = q.QuestionGroupId,
                    QuestionNumber = q.QuestionNumber,
                    Content = q.Content,
                    OptionA = q.OptionA,
                    OptionB = q.OptionB,
                    OptionC = q.OptionC,
                    OptionD = q.OptionD,
                    CorrectAnswer = q.CorrectAnswer,
                    PassageText = groupDict.ContainsKey(q.QuestionGroupId) ? groupDict[q.QuestionGroupId] : ""
                }).ToList()
            };

            return result;
        }

        public async Task UpdateQuestionAsync(UpdateQuestionInput input)
        {
            var question = await _questionRepository.GetAsync(input.Id);
            question.Content = input.Content;
            question.OptionA = input.OptionA;
            question.OptionB = input.OptionB;
            question.OptionC = input.OptionC;
            question.OptionD = input.OptionD;
            question.CorrectAnswer = input.CorrectAnswer;
            await _questionRepository.UpdateAsync(question);

            if (!string.IsNullOrEmpty(input.PassageText))
            {
                var group = await _questionGroupRepository.FirstOrDefaultAsync(question.QuestionGroupId);
                if (group != null)
                {
                    group.PassageText = input.PassageText;
                    await _questionGroupRepository.UpdateAsync(group);
                }
            }
        }

        public async Task UpdateExamInfoAsync(int id, string name, int durationInMinutes)
        {
            var exam = await _examRepository.GetAsync(id);
            if (!string.IsNullOrWhiteSpace(name))
            {
                exam.Name = name.Trim();
            }
            if (durationInMinutes > 0)
            {
                exam.DurationInMinutes = durationInMinutes;
            }
            await _examRepository.UpdateAsync(exam);
        }

        public async Task DeleteExamAsync(int examId)
        {
            var groups = await _questionGroupRepository.GetAllListAsync(g => g.ExamId == examId);
            foreach (var g in groups)
            {
                await _questionRepository.DeleteAsync(q => q.QuestionGroupId == g.Id);
                await _questionGroupRepository.DeleteAsync(g.Id);
            }
            await _examRepository.DeleteAsync(examId);
        }

        public async Task ImportExamFromWordAsync(byte[] fileBytes)
        {
            // 1. Đọc nội dung text từ file Word
            string documentText = ExtractTextFromDocx(fileBytes);

            // Kiểm tra thẻ gốc
            if (!documentText.Contains("[TEST") || !documentText.Contains("[/TEST]"))
            {
                throw new UserFriendlyException("File sai định dạng: Thiếu thẻ [TEST] bọc ngoài cùng.");
            }

            // Loại bỏ phần giải thích hướng dẫn [GUIDE]...[/GUIDE] nếu có ở đầu file
            documentText = Regex.Replace(documentText, @"\[GUIDE\].*?\[/GUIDE\]", "", RegexOptions.Singleline);

            // 2. Lấy Tên đề thi từ thẻ [TITLE]
            string examTitle = "Đề thi TOEIC Reading";
            var titleMatch = Regex.Match(documentText, @"\[TITLE\](.*?)(?:\[/TITLE\]|[\r\n])");
            if (titleMatch.Success && !string.IsNullOrWhiteSpace(titleMatch.Groups[1].Value))
            {
                examTitle = titleMatch.Groups[1].Value.Trim();
            }
            else
            {
                var titleMatch2 = Regex.Match(documentText, @"\[TITLE\](.*?)\[/TITLE\]", RegexOptions.Singleline);
                if (titleMatch2.Success && !string.IsNullOrWhiteSpace(titleMatch2.Groups[1].Value))
                {
                    examTitle = titleMatch2.Groups[1].Value.Trim();
                }
            }

            // Kiểm tra số lượng câu hỏi trước khi lưu (phải có câu hỏi hợp lệ)
            var allQuestions = Regex.Matches(documentText, @"\[Q number=(\d+).*?\](.*?)\[/Q\]", RegexOptions.Singleline);
            if (allQuestions.Count == 0)
            {
                throw new UserFriendlyException("File không chứa bất kỳ câu hỏi nào có thẻ [Q number=...].");
            }

            // Kiểm tra từng câu hỏi có đủ đáp án và [ANSWER] không
            var errorList = new List<string>();
            foreach (Match qm in allQuestions)
            {
                int qNum = int.Parse(qm.Groups[1].Value);
                string qBody = qm.Groups[2].Value;

                if (!Regex.IsMatch(qBody, @"\[ANSWER\](.*?)\[/ANSWER\]", RegexOptions.Singleline))
                {
                    errorList.Add($"Câu {qNum}: Thiếu tag [ANSWER] cho đáp án đúng.");
                }
                if (!Regex.IsMatch(qBody, @"\[A\](.*?)\[/A\]") ||
                    !Regex.IsMatch(qBody, @"\[B\](.*?)\[/B\]") ||
                    !Regex.IsMatch(qBody, @"\[C\](.*?)\[/C\]") ||
                    !Regex.IsMatch(qBody, @"\[D\](.*?)\[/D\]"))
                {
                    errorList.Add($"Câu {qNum}: Không tìm thấy đủ 4 phương án trả lời [A], [B], [C], [D].");
                }
            }

            // Nếu có lỗi định dạng -> HỦY BỎ toàn bộ theo đúng yêu cầu đề bài
            if (errorList.Count > 0)
            {
                throw new UserFriendlyException($"Phát hiện {errorList.Count} lỗi trong file:\n" + string.Join("\n", errorList.Take(5)));
            }

            // Lưu Exam vào Database
            var exam = new Exam
            {
                Name = examTitle,
                TotalQuestions = allQuestions.Count,
                DurationInMinutes = 75
            };
            int examId = await _examRepository.InsertAndGetIdAsync(exam);

            // 3. Xử lý Part 5
            var part5Match = Regex.Match(documentText, @"\[PART number=5\](.*?)\[/PART\]", RegexOptions.Singleline);
            if (part5Match.Success)
            {
                var p5Group = new QuestionGroup { ExamId = examId, PassageText = "Part 5: Incomplete Sentences" };
                int p5GroupId = await _questionGroupRepository.InsertAndGetIdAsync(p5Group);
                await ParseAndSaveQuestionsAsync(part5Match.Groups[1].Value, p5GroupId);
            }

            // 4. Xử lý Part 6 & 7
            var part67Matches = Regex.Matches(documentText, @"\[PART number=[67]\](.*?)\[/PART\]", RegexOptions.Singleline);
            foreach (Match partMatch in part67Matches)
            {
                string partContent = partMatch.Groups[1].Value;
                var groupMatches = Regex.Matches(partContent, @"\[GROUP.*?\](.*?)\[/GROUP\]", RegexOptions.Singleline);

                foreach (Match groupMatch in groupMatches)
                {
                    string groupContent = groupMatch.Groups[1].Value;
                    var passageMatches = Regex.Matches(groupContent, @"\[PASSAGE.*?\](.*?)\[/PASSAGE\]", RegexOptions.Singleline);
                    StringBuilder fullPassage = new StringBuilder();

                    foreach (Match p in passageMatches)
                    {
                        string rawPassage = p.Groups[1].Value;
                        string cleanPassage = Regex.Replace(rawPassage, @"\[/?(LINE|HEADER|TABLE|ROW|POS|BLANK).*?\]", "\n");
                        fullPassage.AppendLine(cleanPassage.Trim());
                    }

                    var qGroup = new QuestionGroup { ExamId = examId, PassageText = fullPassage.ToString().Trim() };
                    int groupId = await _questionGroupRepository.InsertAndGetIdAsync(qGroup);
                    await ParseAndSaveQuestionsAsync(groupContent, groupId);
                }
            }
        }

        private async Task ParseAndSaveQuestionsAsync(string textToParse, int groupId)
        {
            var qMatches = Regex.Matches(textToParse, @"\[Q number=(\d+).*?\](.*?)\[/Q\]", RegexOptions.Singleline);
            foreach (Match qm in qMatches)
            {
                int qNum = int.Parse(qm.Groups[1].Value);
                string qBody = qm.Groups[2].Value;

                var qText = Regex.Match(qBody, @"\[QUESTION\](.*?)\[/QUESTION\]", RegexOptions.Singleline).Groups[1].Value.Trim();
                qText = Regex.Replace(qText, @"\[BLANK(?:\s+\d+)?\]", "________");
                var optA = Regex.Match(qBody, @"\[A\](.*?)\[/A\]", RegexOptions.Singleline).Groups[1].Value.Trim();
                var optB = Regex.Match(qBody, @"\[B\](.*?)\[/B\]", RegexOptions.Singleline).Groups[1].Value.Trim();
                var optC = Regex.Match(qBody, @"\[C\](.*?)\[/C\]", RegexOptions.Singleline).Groups[1].Value.Trim();
                var optD = Regex.Match(qBody, @"\[D\](.*?)\[/D\]", RegexOptions.Singleline).Groups[1].Value.Trim();
                var ans = Regex.Match(qBody, @"\[ANSWER\](.*?)\[/ANSWER\]", RegexOptions.Singleline).Groups[1].Value.Trim();

                var question = new Question
                {
                    QuestionGroupId = groupId,
                    QuestionNumber = qNum,
                    Content = qText,
                    OptionA = optA,
                    OptionB = optB,
                    OptionC = optC,
                    OptionD = optD,
                    CorrectAnswer = ans
                };

                await _questionRepository.InsertAsync(question);
            }
        }

        private string ExtractTextFromDocx(byte[] fileBytes)
        {
            StringBuilder sb = new StringBuilder();
            using (MemoryStream ms = new MemoryStream(fileBytes))
            {
                using (WordprocessingDocument wordDocument = WordprocessingDocument.Open(ms, false))
                {
                    var body = wordDocument.MainDocumentPart.Document.Body;
                    foreach (var para in body.Elements<Paragraph>())
                    {
                        sb.AppendLine(para.InnerText);
                    }
                }
            }
            return sb.ToString();
        }
    }
}