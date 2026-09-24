import Foundation
import Models

import Foundation
import NaturalLanguage

class ResumeTailorService {
    /// Simple keyword-based tailoring using Natural Language framework.
    /// In a production app, this would be replaced by a CoreML LLM.
    func tailorResume(resumeContent: String, jobDescription: String) -> String {
        let jobKeywords = extractKeywords(from: jobDescription)
        var tailoredContent = resumeContent
        
        for keyword in jobKeywords {
            if !tailoredContent.contains(keyword, caseSensitive: false) {
                tailoredContent += " Also proficient in \(keyword)."
            }
        }
        
        return "Tailored Resume:\n\n\(tailoredContent)"
    }
    
    /// Checks suitability by comparing keywords in resume against job requirements.
    func checkSuitability(resumeContent: String, requirements: String) -> (isSuitable: Bool, message: String) {
        let resumeKeywords = Set(extractKeywords(from: resumeContent))
        let requirementKeywords = Set(extractKeywords(from: requirements))
        
        let matches = resumeKeywords.intersection(requirementKeywords)
        
        if matches.isEmpty {
            return (false, "Your resume doesn't seem to match any of the core requirements (\(requirementKeywords.joined(separator: ", "))).")
        } else {
            return (true, "Great match! You have experience in: \(matches.joined(separator: ", ")).")
        }
    }
    
    private func extractKeywords(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.tokenizing])
        tagger.string = text
        var keywords: [String] = []
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .tokenizing, options: [], cleanupMap: nil) { tag, range in
            let word = String(text[range]).lowercased()
            // We look for words longer than 3 chars to avoid common stop words
            if word.count > 3 {
                keywords.append(word)
            }
            return true
        }
        
        // Filter out common words (simple mock for stop words)
        let stopWords: Set = ["with", "from", "their", "about", "under", "these", "those"]
        return Array(Set(keywords.filter { !stopWords.contains($0) }))
    }
}

