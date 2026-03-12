import javax.tools.*;
import java.util.*;
import java.io.*;

public class CompileTest {
    public static void main(String[] args) throws Exception {
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<>();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(diagnostics, null, null);

        Iterable<? extends JavaFileObject> compilationUnits = fileManager
                .getJavaFileObjectsFromStrings(Arrays.asList("src/java/controller/AdminController.java"));

        List<String> options = Arrays.asList(
                "-cp", "lib/*;build/web/WEB-INF/lib/*;C:/Program Files/Apache Software Foundation/Tomcat 10.1/lib/*");

        JavaCompiler.CompilationTask task = compiler.getTask(null, fileManager, diagnostics, options, null,
                compilationUnits);

        boolean success = task.call();
        try (PrintWriter out = new PrintWriter("clean_errors.txt")) {
            for (Diagnostic<? extends JavaFileObject> diagnostic : diagnostics.getDiagnostics()) {
                out.println("Line " + diagnostic.getLineNumber() + ": " + diagnostic.getMessage(null));
            }
            out.println("Success: " + success);
        }
    }
}
