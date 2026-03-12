import subprocess
import os

files_to_export = [
    ("src/java/dal/EmployeeDAO.java", "dung_EmployeeDAO.java"),
    ("src/java/dal/ReaderDAO.java", "dung_ReaderDAO.java"),
    ("src/java/dal/RoleDAO.java", "dung_RoleDAO.java"),
    ("src/java/controller/admin/AdminEmployeeListServlet.java", "dung_AdminEmployeeListServlet.java"),
    ("src/java/controller/admin/AdminReaderListServlet.java", "dung_AdminReaderListServlet.java"),
    ("src/java/controller/admin/AdminRoleListServlet.java", "dung_AdminRoleListServlet.java"),
    ("web/admin/employee-list.jsp", "dung_employee_list.jsp"),
    ("web/admin/employee-form.jsp", "dung_employee_form.jsp"),
    ("web/admin/reader-list.jsp", "dung_reader_list.jsp"),
]

for git_path, local_name in files_to_export:
    print(f"Exporting {git_path}")
    try:
        result = subprocess.run(["git", "show", f"origin/dũng:{git_path}"], capture_output=True, text=True, check=True, encoding="utf-8")
        with open(local_name, "w", encoding="utf-8") as f:
            f.write(result.stdout)
    except Exception as e:
        print(f"Error for {git_path}: {e}")
