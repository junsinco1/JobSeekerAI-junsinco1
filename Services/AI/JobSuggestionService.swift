import Foundation
import Models

import Foundation
import Models
import NaturalLanguage

class JobSuggestionService {
    /// Suggests jobs based on keyword matching between resume and job description/requirements.
    /// In a production app, this would be replaced by a CoreML LLM.
    func suggestJobs(from resumeContent: String, allJobs: [Job]) -> [Job] {
        let resumeKeywords = Set(extractKeywords(from: resumeContent))
        
        var results: [Job] = []
        for job in allJobs {
            let jobKeywords = Set(extractKeywords(from: job.description + " " + job.requirements))
            let matches = resumeKeywords.intersection(jobKeywords)
            
            if !matches.isEmpty {
                let score = Double(matches.count)
                job.aiSuitabilityScore = score
                job.aiSuitabilityMessage = "Matches \(matches.count) of your skills."
                results.append(job)
            }
        }
        
        return results.sorted { (j1, j2) in
            (j1.aiSuitabilityScore ?? 0) > (j2.aiSuitabilityScore ?? 0)
        }
    }
    
    private func extractKeywords(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.tokenizing])
        tagger.string = text
        var keywords: [String] = []
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .tokenizing, options: [], cleanupMap: nil) { tag, range in
            let word = String(text[range]).lowercased()
            if word.count > 3 {
                keywords.append(word)
            }
            return true
        }
        
        let stopWords: Set = ["with", "from", "their", "about", "under", "these", "those"]
        return Array(Set(keywords.filter { !stopWords.contains($0) }))
    }
}

