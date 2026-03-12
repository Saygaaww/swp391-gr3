import javax.tools.*;
import java.util.*;
import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

public class CompileAll {
    public static void main(String[] args) throws Exception {
        List<File> javaFiles = Files.walk(Paths.get("src/java"))
                .filter(Files::isRegularFile)
                .filter(p -> p.toString().endsWith(".java"))
                .map(Path::toFile)
                .collect(Collectors.toList());

        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<>();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(diagnostics, null, null);

        Iterable<? extends JavaFileObject> compilationUnits = fileManager.getJavaFileObjectsFromFiles(javaFiles);

        String cp = Files.walk(Paths.get("."))
                .filter(p -> p.toString().endsWith(".jar") && !p.toString().contains("tmp"))
                .map(Path::toAbsolutePath)
                .map(Path::toString)
                .collect(Collectors.joining(";"));
        cp += ";C:\\Users\\tenma\\OneDrive\\Documents\\NetBeansProjects\\Library\\apache-tomcat-10.1.28\\lib\\servlet-api.jar";
        Files.write(Paths.get("classpath_used.txt"), cp.getBytes(StandardCharsets.UTF_8));
        List<String> options = Arrays.asList("-encoding", "UTF-8", "-cp", cp);
        JavaCompiler.CompilationTask task = compiler.getTask(null, fileManager, diagnostics, options, null,
                compilationUnits);

        boolean success = task.call();
        try (PrintWriter out = new PrintWriter("clean_errors_all.txt")) {
            for (Diagnostic<? extends JavaFileObject> diagnostic : diagnostics.getDiagnostics()) {
                if (diagnostic.getSource() != null) {
                    out.println(diagnostic.getSource().getName() + ":" + diagnostic.getLineNumber() + " - "
                            + diagnostic.getMessage(null));
                } else {
                    out.println("Global error: " + diagnostic.getMessage(null));
                }
            }
            out.println("Success: " + success);
        }
    }
}
