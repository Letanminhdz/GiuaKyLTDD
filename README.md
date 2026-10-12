# BÁO CÁO BÀI TẬP GIỮA KỲ: ỨNG DỤNG THI TRẮC NGHIỆM TIẾNG ANH (TOEIC)

* **Môn học:** Lập trình Thiết bị Di động
* **Sinh viên thực hiện:** Lê Tấn Minh
* **GitHub Repository:** [https://github.com/Letanminhdz/GiuaKyLTDD.git](https://github.com/Letanminhdz/GiuaKyLTDD.git)
* **Link Figma Design:** [https://write-mode-13691938.figma.site](https://write-mode-13691938.figma.site)
* **Kiến trúc hệ thống:** Phân tách độc lập 2 phần:
  1. **Frontend (Mobile App):** Flutter / Dart (chuẩn thiết kế Figma)
  2. **Backend (Server & Admin Web):** C# ASP.NET Core 9.0 ABP Boilerplate & SQL Server

---

## 📹 VIDEO DEMO HỆ THỐNG

> File video demo chất lượng cao đã được đính kèm trực tiếp trong thư mục gốc của repository: **[`demo_video.mp4`](demo_video.mp4)**.

### Nội dung trình diễn trong Video Demo:
1. **Đăng nhập phân quyền:**
   * Tài khoản **Admin** (`admin` / `123qwe`): Đăng nhập trang quản trị máy tính để tải lên file đề thi `.docx`, chỉnh sửa thông tin đề, thời gian làm bài và các câu hỏi.
   * Tài khoản **User** (`user` / `123qwe`): Đăng nhập giao diện học viên với khung giao diện mô phỏng điện thoại di động (chuẩn tỉ lệ & màu sắc Figma).
2. **Quản trị đề thi (Admin):**
   * Import file đề thi Word định dạng chuẩn TOEIC (tự động phân loại Part 5, 6, 7).
   * Chỉnh sửa trực tiếp tên đề, thời gian thi, nội dung câu hỏi, đáp án A/B/C/D và đáp án chính xác.
3. **Trải nghiệm thi của thí sinh (User):**
   * **Danh sách đề thi (Catalog):** Hiển thị thẻ đề thi TOEIC, số câu hỏi, thời lượng làm bài, nút "Bắt đầu làm bài".
   * **Phòng thi (Exam Room):** Đồng hồ đếm ngược thời gian thực, câu hỏi hiển thị đường gạch chân `________` trực quan, bài đọc hiểu song song, chuyển câu mượt mà.
   * **Kết quả thi (Result):** Vòng tròn điểm số chuẩn Figma, thống kê số câu đúng/sai/chưa làm, xem lại chi tiết bài làm kèm giải thích đáp án.

---

## 📂 CẤU TRÚC DỰ ÁN

```text
GiuaKyLTDD/
├── 🎥 demo_video.mp4          # Video quay màn hình demo toàn bộ chức năng
├── 📄 README.md               # Tài liệu hướng dẫn & báo cáo dự án
├── 📄 .gitignore              # Bộ lọc loại trừ file build, bin, obj, cache
│
├── 📱 frontend/               # PHẦN 1: MOBILE APP (FLUTTER / DART)
│   ├── lib/
│   │   ├── models/            # Data Models (Exam, Question, ExamResult)
│   │   ├── screens/           # 3 màn hình User: Catalog, Exam, Result
│   │   ├── services/          # API Client kết nối Server & Mock Data offline
│   │   ├── theme/             # Bảng màu, typography, shadow chuẩn Figma
│   │   ├── widgets/           # ScoreRing, OptionCard, QuestionNavSheet,...
│   │   └── main.dart          # Entry point ứng dụng di động
│   └── pubspec.yaml
│
└── 💻 backend/                # PHẦN 2: SERVER & ADMIN WEB (C# / .NET 9 ABP)
    ├── src/
    │   ├── GiuaKi.Application/         # Xử lý nghiệp vụ, Bộ phân tích file Word .docx
    │   ├── GiuaKi.Core/                # Entity CSDL (Exams, QuestionGroups, Questions)
    │   ├── GiuaKi.EntityFrameworkCore/ # DbContext, SQL Server Migrations, Seeders
    │   └── GiuaKi.Web.Mvc/             # Controller, Views Admin & Student Mobile Mockup
    └── GiuaKi.sln
```

---

## 🔐 TÀI KHOẢN MẶC ĐỊNH

Hệ thống đã được khởi tạo sẵn 2 tài khoản mặc định phục vụ chấm điểm và kiểm thử:

| Loại tài khoản | Tên đăng nhập | Mật khẩu | Phạm vi sử dụng |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` | `123qwe` | Quản trị viên: Import đề thi Word `.docx`, chỉnh sửa câu hỏi, quản lý bài thi |
| **User** | `user` | `123qwe` | Thí sinh: Xem danh sách đề thi, vào phòng thi đếm giờ, xem bảng điểm kết quả |

---

## 🚀 HƯỚNG DẪN CÀI ĐẶT & CHẠY DỰ ÁN

### 1. Chuẩn bị môi trường
* **.NET SDK:** 9.0
* **Flutter SDK:** 3.x+ (kèm Android SDK hoặc Chrome/Windows desktop)
* **SQL Server:** SQL Server 2019/2022 hoặc SQL Server Express (Database: `GiuaKiDb`)

### 2. Khởi chạy Backend (C# ASP.NET Core)
1. Cấu hình chuỗi kết nối trong file `backend/src/GiuaKi.Web.Mvc/appsettings.json`:
   ```json
   "ConnectionStrings": {
     "Default": "Server=localhost; Database=GiuaKiDb; Trusted_Connection=True; TrustServerCertificate=True;"
   }
   ```
2. Chạy ứng dụng Web:
   ```bash
   cd backend/src/GiuaKi.Web.Mvc
   dotnet run
   ```
3. Truy cập trình duyệt:
   * **URL chính:** `https://localhost:44312` (hoặc `http://localhost:5000`)
   * Đăng nhập tài khoản `admin` để quản trị đề thi.
   * Đăng nhập tài khoản `user` để trải nghiệm giao diện thi mô phỏng điện thoại di động chuẩn Figma.

### 3. Khởi chạy Frontend (Flutter Mobile App)
1. Di chuyển vào thư mục frontend:
   ```bash
   cd frontend
   flutter pub get
   ```
2. Chạy ứng dụng trên thiết bị / máy ảo:
   ```bash
   flutter run
   ```
   *(Hệ thống hỗ trợ chạy tự động kết nối Backend API hoặc chạy Offline Fallback với bộ câu hỏi chuẩn TOEIC).*

---

## ⭐ CÁC ĐẶC TẢ TÍNH NĂNG NỔI BẬT ĐÃ HOÀN THIỆN

1. **Import đề thi chuẩn TOEIC thông minh:**
   * Tự động quét thẻ cấu trúc: `[EXAM]`, `[TIME]`, `[GROUP]`, `[PASSAGE]`, `[Q]`, `[A]`, `[B]`, `[C]`, `[D]`, `[ANS]`.
   * Tự động thay thế các ký hiệu `[BLANK]` thành đường gạch dưới `________` cho câu hỏi điền từ Part 5.
   * Cơ chế kiểm tra định dạng chặt chẽ, hiển thị thông báo lỗi chi tiết nếu file Word thiếu đáp án.
2. **Chỉnh sửa đề thi linh hoạt:**
   * Cho phép Admin đổi tên đề, thời gian thi, và trực tiếp sửa từng câu hỏi/đáp án sau khi import.
3. **Giao diện User Web Mobile Mockup:**
   * Khung hiển thị mô phỏng điện thoại di động (Dynamic Island, Status Bar, Bottom Navigation Bar) giúp thí sinh có trải nghiệm đồng nhất giữa Web và Mobile.
4. **Trải nghiệm làm bài thi hoàn chỉnh:**
   * Đồng hồ đếm ngược tự động nộp bài khi hết giờ.
   * Bộ câu hỏi hỗ trợ bài đọc hiểu song song, danh sách chọn nhanh câu hỏi (Question Navigation Sheet).
   * Bảng kết quả trực quan hiển thị tỉ lệ đúng/sai và lời giải chi tiết.
