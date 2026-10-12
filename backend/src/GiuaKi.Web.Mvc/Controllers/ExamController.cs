using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
using System.IO;
using System.Text;
using System;
using GiuaKi.Controllers;
using GiuaKi.Exams;

namespace GiuaKi.Web.Mvc.Controllers
{
    public class ExamController : GiuaKiControllerBase
    {
        private readonly IExamAppService _examAppService;

        public ExamController(IExamAppService examAppService)
        {
            _examAppService = examAppService;
        }

        // 1. Màn hình Import đề thi (Chỉ dành cho Admin)
        public async Task<ActionResult> Index()
        {
            if (User.Identity?.Name?.Equals("user", StringComparison.OrdinalIgnoreCase) == true)
            {
                return RedirectToAction("Catalog", "Student");
            }

            var exams = await _examAppService.GetExamsAsync();
            return View(exams);
        }

        // Xử lý Upload file Word .docx
        [HttpPost]
        public async Task<ActionResult> UploadWordFile(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                TempData["Error"] = "Vui lòng chọn tệp Word (.docx) để upload.";
                return RedirectToAction("Index");
            }

            if (!file.FileName.EndsWith(".docx", StringComparison.OrdinalIgnoreCase))
            {
                TempData["Error"] = "Định dạng không hợp lệ! Hệ thống chỉ chấp nhận tệp .docx.";
                return RedirectToAction("Index");
            }

            using (var ms = new MemoryStream())
            {
                await file.CopyToAsync(ms);
                var fileBytes = ms.ToArray();
                
                try 
                {
                    await _examAppService.ImportExamFromWordAsync(fileBytes);
                    TempData["Success"] = $"Import đề thi thành công từ tệp '{file.FileName}'!";
                }
                catch (Exception ex)
                {
                    TempData["Error"] = ex.Message; 
                }
            }
            return RedirectToAction("Index");
        }

        // 2. Màn hình Rà soát / Chỉnh sửa nội dung đề thi sau khi import
        public async Task<ActionResult> Edit(int id)
        {
            if (User.Identity?.Name?.Equals("user", StringComparison.OrdinalIgnoreCase) == true)
            {
                return RedirectToAction("Catalog", "Student");
            }

            try
            {
                var exam = await _examAppService.GetExamDetailAsync(id);
                return View(exam);
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Không tìm thấy đề thi: " + ex.Message;
                return RedirectToAction("Index");
            }
        }

        // Cập nhật chi tiết câu hỏi
        [HttpPost]
        public async Task<ActionResult> UpdateQuestion(UpdateQuestionInput input, int examId)
        {
            try
            {
                await _examAppService.UpdateQuestionAsync(input);
                TempData["Success"] = $"Đã lưu chỉnh sửa câu số {input.Id} thành công!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi khi cập nhật câu hỏi: " + ex.Message;
            }
            return RedirectToAction("Edit", new { id = examId });
        }

        // Cập nhật thông tin tiêu đề và thời lượng đề thi
        [HttpPost]
        public async Task<ActionResult> UpdateExamInfo(int id, string name, int durationInMinutes)
        {
            try
            {
                await _examAppService.UpdateExamInfoAsync(id, name, durationInMinutes);
                TempData["Success"] = "Đã cập nhật thông tin tiêu đề đề thi thành công!";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Lỗi khi cập nhật đề thi: " + ex.Message;
            }
            return RedirectToAction("Edit", new { id });
        }

        // Xóa đề thi
        [HttpPost]
        public async Task<ActionResult> Delete(int id)
        {
            try
            {
                await _examAppService.DeleteExamAsync(id);
                TempData["Success"] = "Đã xóa đề thi thành công.";
            }
            catch (Exception ex)
            {
                TempData["Error"] = "Không thể xóa đề thi: " + ex.Message;
            }
            return RedirectToAction("Index");
        }

        // Tải file mẫu chuẩn (.docx)
        public ActionResult DownloadSample()
        {
            string sampleContent = 
                "[TEST]\n" +
                "[TITLE] Đề Thi Thử TOEIC Reading Chuẩn 2025 [/TITLE]\n" +
                "[PART number=5]\n" +
                "[Q number=1]\n" +
                "[QUESTION] Choose the word whose underlined part is pronounced differently from the others. [/QUESTION]\n" +
                "[A] climate [/A]\n" +
                "[B] village [/B]\n" +
                "[C] wildlife [/C]\n" +
                "[D] invite [/D]\n" +
                "[ANSWER] B [/ANSWER]\n" +
                "[/Q]\n" +
                "[Q number=2]\n" +
                "[QUESTION] The new software will allow employees to work more -------- from home. [/QUESTION]\n" +
                "[A] efficient [/A]\n" +
                "[B] efficiency [/B]\n" +
                "[C] efficiently [/C]\n" +
                "[D] more efficient [/D]\n" +
                "[ANSWER] C [/ANSWER]\n" +
                "[/Q]\n" +
                "[/PART]\n" +
                "[/TEST]\n";

            byte[] bytes = Encoding.UTF8.GetBytes(sampleContent);
            return File(bytes, "text/plain", "de-thi-mau-chuan-toeic.txt");
        }
    }
}