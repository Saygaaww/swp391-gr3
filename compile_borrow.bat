@echo off
set BUILD=d:\Ki5\SWP\Clone-Project\swp391-gr3\build\web\WEB-INF\classes
set LIB=d:\Ki5\SWP\Clone-Project\swp391-gr3\build\web\WEB-INF\lib\*
set SRC=d:\Ki5\SWP\Clone-Project\swp391-gr3\src\java

javac -cp "%BUILD%;%LIB%" -d "%BUILD%" ^
  "%SRC%\dal\DBContext.java" ^
  "%SRC%\model\BorrowRequest.java" ^
  "%SRC%\dal\BorrowDAO.java" ^
  "%SRC%\controller\CustomerController.java" ^
  "%SRC%\controller\admin\AdminBorrowApproveServlet.java" ^
  "%SRC%\controller\admin\AdminBorrowDetailServlet.java"

echo Compile exit: %ERRORLEVEL%
