using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using System;
using System.Collections.Generic;
using System.Linq;
using GiuaKi.Controllers;
using GiuaKi.Exams;

namespace GiuaKi.Web.Mvc.Controllers
{
    public class StudentController : GiuaKiControllerBase
    {
        private readonly IExamAppService _examAppService;

        public StudentController(IExamAppService examAppService)
        {
            _examAppService = examAppService;
        }

        // 1. Danh sách đề thi (Catalog)
        public async Task<ActionResult> Catalog()
        {
            var exams = await _examAppService.GetExamsAsync();
            return View(exams);
        }

        // 2. Phòng thi (Làm bài thi)
        public async Task<ActionResult> Room(int? id)
        {
            var exams = await _examAppService.GetExamsAsync();
            if (exams == null || !exams.Any())
            {
                TempData["Error"] = "Chưa có đề thi nào trong hệ thống.";
                return RedirectToAction("Catalog");
            }

            int examId = id ?? exams.First().Id;
            try
            {
                var exam = await _examAppService.GetExamDetailAsync(examId);
                return View(exam);
            }
            catch
            {
                var fallbackExam = await _examAppService.GetExamDetailAsync(exams.First().Id);
                return View(fallbackExam);
            }
        }

        // 3. Nộp bài thi
        [HttpPost]
        public async Task<ActionResult> Submit(int examId, string answersJson, int timeSpentSeconds)
        {
            var exam = await _examAppService.GetExamDetailAsync(examId);
            
            // Parse answers: { "1": "A", "2": "B", ... }
            var userAnswers = new Dictionary<string, string>();
            if (!string.IsNullOrEmpty(answersJson))
            {
                try
                {
                    userAnswers = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(answersJson) 
                        ?? new Dictionary<string, string>();
                }
                catch { }
            }

            int correctCount = 0;
            int wrongCount = 0;
            int skippedCount = 0;

            foreach (var q in exam.Questions)
            {
                string qKey = q.QuestionNumber.ToString();
                if (userAnswers.TryGetValue(qKey, out string ans) && !string.IsNullOrWhiteSpace(ans))
                {
                    if (string.Equals(ans.Trim(), q.CorrectAnswer?.Trim(), StringComparison.OrdinalIgnoreCase))
                    {
                        correctCount++;
                    }
                    else
                    {
                        wrongCount++;
                    }
                }
                else
                {
                    skippedCount++;
                }
            }

            int totalQuestions = exam.Questions.Count > 0 ? exam.Questions.Count : 1;
            double score = Math.Round((double)correctCount / totalQuestions * 10, 1);

            TempData["ExamTitle"] = exam.Name;
            TempData["Score"] = score.ToString("0.0");
            TempData["CorrectCount"] = correctCount;
            TempData["WrongCount"] = wrongCount;
            TempData["SkippedCount"] = skippedCount;
            TempData["TotalCount"] = totalQuestions;
            TempData["TimeSpent"] = $"{timeSpentSeconds / 60}m {timeSpentSeconds % 60}s";
            TempData["LastResult_Answers"] = answersJson ?? "{}";
            TempData["LastResult_ExamId"] = examId;

            return RedirectToAction("Result");
        }

        // 4. Kết quả bài thi (Result)
        public async Task<ActionResult> Result()
        {
            int? examId = TempData["LastResult_ExamId"] as int?;
            TempData.Keep("LastResult_ExamId");

            ExamWithQuestionsDto exam = null;
            if (examId.HasValue)
            {
                try
                {
                    exam = await _examAppService.GetExamDetailAsync(examId.Value);
                }
                catch { }
            }
            else
            {
                var exams = await _examAppService.GetExamsAsync();
                if (exams.Any())
                {
                    try { exam = await _examAppService.GetExamDetailAsync(exams.First().Id); } catch { }
                }
            }

            string answersJson = TempData["LastResult_Answers"] as string ?? "{}";
            TempData.Keep("LastResult_Answers");

            ViewBag.UserAnswers = Newtonsoft.Json.JsonConvert.DeserializeObject<Dictionary<string, string>>(answersJson) 
                ?? new Dictionary<string, string>();

            return View(exam);
        }
    }
}

