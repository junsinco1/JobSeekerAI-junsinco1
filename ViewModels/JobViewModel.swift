import Foundation
import SwiftData
import SwiftUI

@MainActor
class JobViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var filteredJobs: [Job] = []
    @Published var suggestions: [Job] = []
    
    var searchText: String = ""
    var selectedJobType: String?
    var selectedWorkMode: String?
    var minWage: Double = 0.0
    
    private let suggestionService = JobSuggestionService()
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchJobs()
    }
    
    func fetchJobs() {
        let descriptor = FetchDescriptor<Job>(sortBy: [SortDescriptor(\.title)])
        do {
            jobs = try modelContext.fetch(descriptor)
            applyFilters()
        } catch {
            print("Failed to fetch jobs: \(error)")
        }
    }
    
    func applyFilters() {
        filteredJobs = jobs.filter { job in
            let matchesSearch = job.title.localizedCaseInsensitiveContains(searchText) || job.company.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedJobType == nil || job.jobType == selectedJobType
            let matchesMode = selectedWorkMode == nil || job.workMode == selectedWorkMode
            let matchesWage = job.wage >= minWage
            return matchesSearch && matchesType && matchesMode && matchesWage
        }
    }
    
    func updateSuggestions(resumeContent: String) {
        suggestions = suggestionService.suggestJobs(from: resumeContent, allJobs: jobs)
    }
    
    func getSuggestions(from resumeContent: String) -> [Job] {
        return suggestionService.suggestJobs(from: resumeContent, allJobs: jobs)
    }
}
