import Foundation
import PDFKit

class ResumeParserService {
    /// Parses raw text content into a Resume object.
    func parseFromText(name: String, content: String) -> Resume {
        return Resume(name: name, content: content)
    }
    
    /// Parses a PDF/Docx file and returns a Resume object.
    func parseFile(url: URL) -> Resume? {
        print("Parsing file from: \(url.path)")
        
        let extensionName = url.pathExtension.lowercased()
        
        if extensionName == "pdf" {
            guard let document = PDFDocument(url: url) else { return nil }
            var fullText = ""
            for i in 0..<document.pageCount {
                if let page = document.page(at: i) {
                    // PDFKit's string extraction is limited. 
                    // For a production app, a more robust library or OCR might be needed.
                    // For now, we'll try to extract what we can.
                    fullText += page.string ?? ""
                }
            }
            let name = url.deletingPathExtension().lastPathComponent
            return Resume(name: name, content: fullText)
        } else if extensionName == "docx" {
            if let content = try? String(contentsOf: url, encoding: .utf8) {
                let name = url.deletingPathExtension().lastPathComponent
                return Resume(name: name, content: content)
            }
        }
        
        return nil
    }
}
