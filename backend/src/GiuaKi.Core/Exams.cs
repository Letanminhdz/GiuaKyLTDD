using Abp.Domain.Entities.Auditing;
using System.Collections.Generic;

// Bảng lưu thông tin chung của đề thi
public class Exam : FullAuditedEntity<int>
{
    public string Name { get; set; }
    public int DurationInMinutes { get; set; } = 75; // 75 phút theo yêu cầu
    public int TotalQuestions { get; set; }
    public ICollection<QuestionGroup> QuestionGroups { get; set; }
}

// Bảng lưu nhóm câu hỏi (Hỗ trợ Part 6, Part 7 có đoạn văn/hình ảnh)
public class QuestionGroup : FullAuditedEntity<int>
{
    public int ExamId { get; set; }
    public string PassageText { get; set; } // Nội dung bài đọc
    public string ImageUrl { get; set; } 
    public ICollection<Question> Questions { get; set; }
}

// Bảng lưu chi tiết từng câu hỏi và đáp án
public class Question : FullAuditedEntity<int>
{
    public int QuestionGroupId { get; set; }
    public int QuestionNumber { get; set; } // Số thứ tự câu (vd: 101)
    public string Content { get; set; }
    public string OptionA { get; set; }
    public string OptionB { get; set; }
    public string OptionC { get; set; }
    public string OptionD { get; set; }
    public string CorrectAnswer { get; set; } // Đáp án đúng
}