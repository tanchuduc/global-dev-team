---
name: multi-agent-orchestrator
description: >-
  Kỹ năng điều phối hệ thống Global Multi-Agent trên Antigravity.
  Kích hoạt khi người dùng yêu cầu: "Dùng Multi-Agent để...", "Phát triển tính năng với Multi-Agent...",
  "Lập kế hoạch Multi-Agent...", "Review toàn diện dự án...", hoặc bất kỳ yêu cầu cộng tác nhiều Agent nào.
---

# Multi-Agent Orchestrator Skill

Kỹ năng này hướng dẫn Agent chính (Primary Agent) đóng vai trò **Project Manager / Orchestrator** để điều phối đội ngũ 5 Subagents chuyên trách: `backend-developer`, `frontend-developer`, `qa-tester`, `code-reviewer`, và `project-manager`.

## 1. Nhận Diện Mục Tiêu & Phân Loại Task (Task Sizing)

Khi Product Owner yêu cầu phát triển hoặc kiểm tra bằng Multi-Agent:
1. **Quick Task** (Sửa text, đổi CSS, fix lỗi nhỏ trong 1 file):
   - Chọn duy nhất 1 Developer phù hợp (`frontend-developer` hoặc `backend-developer`).
   - Gọi trực tiếp qua `invoke_subagent`.
   - Tự xác minh nhanh qua linter/typecheck, không cần khởi động toàn bộ đội ngũ.
2. **Standard Task** (Thêm endpoint nhỏ, tạo component, sửa bug 2-4 files):
   - Phân tích yêu cầu và xác định phạm vi file.
   - Gọi Developer phù hợp thực hiện.
   - Sau khi Developer hoàn thành, gọi `qa-tester` (hoặc `code-reviewer`) kiểm tra chéo.
3. **Complex Task** (Module mới, thay đổi Database schema, luồng thanh toán, tính năng lớn):
   - Lập kế hoạch chi tiết, phân rã công việc thành các task con độc lập.
   - Gọi `backend-developer` và `frontend-developer`. Nếu 2 task độc lập, gọi đồng thời (Parallel execution) với `Workspace: "inherit"` (hoặc `"share"` nếu cần git worktree isolation).
   - Tích hợp kết quả, sau đó gọi `qa-tester` viết và chạy test.
   - Sau khi test Pass, gọi `code-reviewer` kiểm tra bảo mật và diff.
   - Kiểm tra Quality Gate 12 tiêu chí trước khi báo cáo PO.

## 2. Quy Trình Gọi Native Subagents (`invoke_subagent`)

### Backend Developer
```json
{
  "TypeName": "backend-developer",
  "Role": "Backend & Database Engineer",
  "Model": "inherit",
  "Workspace": "inherit",
  "Prompt": "Mục tiêu cụ thể...\nPhạm vi file: [...]\nTiêu chí nghiệm thu: [...]\nKiểm tra: chạy typecheck/test liên quan trước khi hoàn tất."
}
```

### Frontend Developer
```json
{
  "TypeName": "frontend-developer",
  "Role": "Frontend UI/UX Specialist",
  "Model": "inherit",
  "Workspace": "inherit",
  "Prompt": "Mục tiêu giao diện...\nPhạm vi file: [...]\nDesign system & responsive requirements...\nXử lý loading, error, empty, success states."
}
```

### QA Tester
```json
{
  "TypeName": "qa-tester",
  "Role": "QA & Test Engineer",
  "Model": "flash",
  "Workspace": "inherit",
  "Prompt": "Kiểm thử các thay đổi vừa thực hiện...\nChạy các bài test sau: [...]\nBáo cáo kết quả theo PASSED / FAILED / NOT RUN kèm bằng chứng log."
}
```

### Code Reviewer
```json
{
  "TypeName": "code-reviewer",
  "Role": "Security Auditor & Code Reviewer",
  "Model": "inherit",
  "Workspace": "inherit",
  "Prompt": "Review git diff các file vừa thay đổi: [...]\nKiểm tra code smells, scope creep, và lỗ hổng bảo mật (OWASP, RBAC, Injection).\nPhân loại rủi ro: CRITICAL, HIGH, MEDIUM, LOW."
}
```

## 3. Quản Lý Tiến Độ & Vòng Lặp Sửa Lỗi (Auto-Fix)
- Khi QA Tester hoặc Code Reviewer phát hiện lỗi:
  1. Giao lỗi lại cho đúng Developer phụ trách kèm các bước tái hiện (reproduction steps) và logs.
  2. Tối đa 3 vòng lặp tự sửa chữa cho cùng một vấn đề.
  3. Nếu sau 3 lần vẫn thất bại, dừng lại và tạo báo cáo blocker cho PO.

## 4. Báo Cáo Bàn Giao Cho Product Owner
Sau khi vượt qua Quality Gate, tạo báo cáo ngắn gọn, rõ ràng theo đúng 6 mục:
1. Đã thực hiện những gì?
2. Agent nào đã tham gia?
3. Kết quả kiểm chứng (Quality Gate)?
4. Những gì chưa thể kiểm chứng tự động?
5. Rủi ro hoặc lưu ý còn tồn tại?
6. Đề xuất bước tiếp theo & Yêu cầu PO phê duyệt.
