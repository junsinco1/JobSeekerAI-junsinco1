import SwiftUI

struct DashboardView: View {
    @StateObject var jobViewModel: JobViewModel
    @StateObject var resumeViewModel: ResumeViewModel
    
    init(modelContext: ModelContext) {
        _jobViewModel = StateObject(wrappedValue: JobViewModel(modelContext: modelContext))
        _resumeViewModel = StateObject(wrappedValue: ResumeViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Greeting
                    VStack(alignment: .leading) {
                        Text("Hello, Job Seeker!")
                            .font(.largeTitle)
                            .bold()
                        Text("Your AI-powered job search summary.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Quick Actions
                    HStack(spacing: 15) {
                        NavigationLink(destination: ResumeListView(modelContext: modelContext)) {
                            VStack {
                                Image(systemName: "doc.badge.plus")
                                    .font(.largeTitle)
                                Text("Upload")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(15)
                        }
                        
                        NavigationLink(destination: JobSuggestionsView(viewModel: jobViewModel, resumeContent: resumeViewModel.selectedResume?.content ?? "")) {
                            VStack {
                                Image(systemName: "sparkles")
                                    .font(.largeTitle)
                                Text("AI Insights")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity, minHeight: 100)
                            .background(Color.purple.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                    
                    // AI Suggestions Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Top AI Suggestions")
                            .font(.headline)
                        
                        if jobViewModel.suggestions.isEmpty {
                            Text("No suggestions yet. Update your resume to see matches.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(jobViewModel.suggestions.prefix(2)) { job in
                                NavigationLink(destination: JobDetailView(job: job)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(job.title).font(.headline)
                                            Text(job.company).font(.subheadline)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(15)
                    
                    // Recent Jobs
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Jobs")
                            .font(.headline)
                        if jobViewModel.jobs.isEmpty {
                            Text("No recent jobs found.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(jobViewModel.jobs.prefix(3)) { job in
                                NavigationLink(destination: JobDetailView(job: job)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(job.title).font(.body)
                                            Text(job.company).font(.caption)
                                        }
                                        Spacer()
                                        Text("$\(job.wage)").font(.caption).bold()
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .onAppear {
                if let content = resumeViewModel.selectedResume?.content {
                    jobViewModel.updateSuggestions(resumeContent: content)
                }
            }
        }
    }
}
