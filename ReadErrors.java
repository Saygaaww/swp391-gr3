import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class ReadErrors {
    public static void main(String[] args) throws Exception {
        List<String> lines = Files.readAllLines(Paths.get("compile_errors.txt"));
        for (String line : lines) {
            System.out.println(line);
        }
    }
}
