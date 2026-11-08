# Global Multi-Agent Collaboration Protocol

Quy chuẩn vận hành hệ thống Global Multi-Agent dành cho Antigravity. Quy chuẩn này áp dụng tự động cho mọi dự án và không làm thay đổi các rules nội bộ riêng của từng workspace.

---

## 1. Nguyên Tắc Điều Phối & Tối Ưu Quota
1. **Không kích hoạt toàn bộ 5 Agent cho mọi tác vụ**:
   - **Quick Task** (sửa text, CSS nhỏ, fix typo): Chỉ kích hoạt 1 Developer phù hợp. Kiểm tra nhanh bằng typecheck/lint và diff.
   - **Standard Task** (thêm API nhỏ, thêm component, fix bug 2-4 files): Project Manager điều phối 1 Developer + QA Tester (hoặc Code Reviewer).
   - **Complex Task** (module mới, thay đổi schema DB, quy trình đa bước): Project Manager điều phối Backend Dev + Frontend Dev (chạy song song khi độc lập) → QA Tester → Code Reviewer.
2. **Ngữ cảnh tối thiểu (Surgical Context)**:
   - Không chuyển toàn bộ mã nguồn vào prompt của Subagent.
   - Chỉ truyền các file liên quan trực tiếp, acceptance criteria, và file interface/types.
3. **Giới hạn vòng lặp sửa lỗi (Auto-Fix Loop)**:
   - Tối đa 3 vòng lặp tự sửa chữa cho cùng một lỗi. Nếu sau 3 lần vẫn không đạt, Project Manager phải dừng lại và báo cáo blocker cho Product Owner.

---

## 2. Phân Quyền Công Cụ & Ranh Giới An Toàn
1. **Developer (Backend / Frontend)**:
   - Có quyền đọc, ghi, chỉnh sửa file trong phạm vi được giao.
   - Có quyền chạy lệnh build, typecheck, test nội bộ.
   - KHÔNG được sửa file ngoài danh sách được giao.
2. **QA Tester**:
   - Có quyền đọc file, chạy lệnh test, viết file test mới trong thư mục kiểm thử.
   - TUYỆT ĐỐI KHÔNG sửa code nguồn ứng dụng.
3. **Code Reviewer / Security Auditor**:
   - Có quyền đọc file và chạy các lệnh kiểm tra trạng thái (`git diff`, `git log`, `git status`).
   - TUYỆT ĐỐI KHÔNG sửa hoặc tạo file mã nguồn ứng dụng.

---

## 3. Ranh Giới An Toàn Hệ Thống (Safety Hard Boundaries)
- **Không tự ý commit vào nhánh chính (`main`, `master`)** mà không có sự đồng ý của Product Owner.
- **Tuyệt đối không force push Git**.
- **Không thực hiện migration phá hủy dữ liệu** (`DROP TABLE`, `DROP COLUMN`) trên môi trường thực tế.
- **Không tự ý deploy production** hoặc sửa đổi biến môi trường nhạy cảm / credentials.
- **Không để lộ secrets / API keys** vào mã nguồn hoặc lịch sử commit.

---

## 4. Quality Gate 12 Tiêu Chí (Thích Ứng Theo Từng Dự Án)
Trước khi bàn giao kết quả cho Product Owner, Project Manager phải kiểm tra:
1. **Đúng phạm vi**: Chỉ thay đổi các file trong kế hoạch.
2. **Không gây hồi quy (No regression)**: Không làm hỏng các tính năng có sẵn.
3. **Linting**: Đạt tiêu chuẩn linter của dự án (nếu dự án có cấu hình eslint, ruff, flake8,...).
4. **Typecheck**: Không phát sinh lỗi kiểu dữ liệu (nếu dự án dùng TypeScript, mypy,...).
5. **Unit Tests**: Các test case liên quan đạt 100% Passed.
6. **Integration Tests**: Luồng tương tác API và dữ liệu chính xác.
7. **Build Status**: Lệnh build ứng dụng thành công (nếu dự án hỗ trợ build).
8. **An ninh mã nguồn**: Không có lỗ hổng bảo mật nghiêm trọng (OWASP, SQLi, IDOR, Session leak).
9. **Bảo mật bí mật**: Không commit passwords, tokens, API keys.
10. **Tiêu chí nghiệm thu (Acceptance Criteria)**: Đã được kiểm chứng bằng thực tế.
11. **Git Cleanliness**: Working tree sạch sẽ, không sót file rác/file tạm.
12. **Báo cáo minh bạch**: Phân biệt rõ ràng kết quả đã chạy test thực tế vs kết quả chưa thể tự động kiểm chứng.
