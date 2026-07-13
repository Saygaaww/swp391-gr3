import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfReader;
import com.itextpdf.kernel.pdf.canvas.parser.PdfTextExtractor;

import java.io.IOException;

public class ReadPdf {
    public static void main(String[] args) {
        try {
            String pdfPath = "d:/Hoc Tap/HUST/Yeu cau BTL (2).pdf";
            PdfReader reader = new PdfReader(pdfPath);
            PdfDocument pdfDoc = new PdfDocument(reader);
            StringBuilder text = new StringBuilder();
            for (int i = 1; i <= pdfDoc.getNumberOfPages(); i++) {
                text.append(PdfTextExtractor.getTextFromPage(pdfDoc.getPage(i)));
                text.append("\n================ PAGE " + i + " ================\n");
            }
            System.out.println(text.toString());
            pdfDoc.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
