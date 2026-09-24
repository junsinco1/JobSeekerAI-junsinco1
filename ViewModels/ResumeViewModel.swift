import Foundation
import SwiftData
import SwiftUI

@MainActor
class ResumeViewModel: ObservableObject {
    @Published var resumes: [Resume] = []
    @Published var selectedResume: Resume?
    
    private let tailorService = ResumeTailorService()
    private let parserService = ResumeParserService()
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchResumes()
    }
    
    func fetchResumes() {
        let descriptor = FetchDescriptor<Resume>(sortBy: [SortDescriptor(\.name)])
        do {
            resumes = try modelContext.fetch(descriptor)
            if let first = resumes.first {
                selectedResume = first
            }
        } catch {
            print("Failed to fetch resumes: \(error)")
        }
    }
    
    func createResume(name: String, content: String) {
        let newResume = Resume(name: name, content: content)
        resumes.append(newResume)
        selectedResume = newResume
        modelContext.insert(newResume)
        try? modelContext.save()
    }
    
    func parseAndSaveResume(url: URL) {
        if let resume = parserService.parseFile(url: url) {
            resumes.append(resume)
            selectedResume = resume
            modelContext.insert(resume)
            try? modelContext.save()
        }
    }
    
    func tailorResume(jobDescription: String) {
        guard let resume = selectedResume else { return }
        let tailored = tailorService.tailorResume(resumeContent: resume.content, jobDescription: jobDescription)
        resume.tailoredContent = tailored
        try? modelContext.save()
    }
    
    func checkSuitability(jobRequirements: String) -> (isSuitable: Bool, message: String) {
        guard let resume = selectedResume else { return (false, "No resume selected.") }
        return tailorService.checkSuitability(resumeContent: resume.content, requirements: jobRequirements)
    }
}
