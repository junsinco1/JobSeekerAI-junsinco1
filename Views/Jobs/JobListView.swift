import SwiftUI
import SwiftData

struct JobListView: View {
    @StateObject var resumeViewModel: ResumeViewModel
    @StateObject var viewModel: JobViewModel
    
    init(modelContext: ModelContext) {
        _resumeViewModel = StateObject(wrappedValue: ResumeViewModel(modelContext: modelContext))
        _viewModel = StateObject(wrappedValue: JobViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !resumeViewModel.resumes.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Picker("Select Resume", selection: $resumeViewModel.selectedResume) {
                            ForEach(resumeViewModel.resumes) { resume in
                                Text(resume.name).tag(resume)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        NavigationLink(destination: JobSuggestionsView(viewModel: viewModel, resumeContent: resumeViewModel.selectedResume?.content ?? "")) {
                            Text("Get AI Suggestions")
                                .font(.headline)
                                .padding()
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                    .padding()
                    
                    if resumeViewModel.resumes.isEmpty {
                        Text("No resumes found. Create one to see AI suggestions.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                
                List(viewModel.filteredJobs) { job in
                    NavigationLink(destination: JobDetailView(job: job)) {
                        VStack(alignment: .leading) {
                            Text(job.title).font(.headline)
                            Text(job.company).font(.subheadline)
                            Text("$\(job.wage)").font(.caption)
                            
                            if let score = job.aiSuitabilityScore {
                                HStack {
                                    Text("Match: \(Int(score))")
                                        .font(.caption2)
                                        .bold()
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.green.opacity(0.1))
                                        .cornerRadius(5)
                                    
                                    if let message = job.aiSuitabilityMessage {
                                        Text(message)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Available Jobs")
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.applyFilters()
            }
            .onAppear {
                viewModel.fetchJobs()
            }
        }
    }
}
