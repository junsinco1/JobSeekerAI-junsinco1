import SwiftUI

struct JobSuggestionsView: View {
    @ObservedObject var viewModel: JobViewModel
    var resumeContent: String
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.suggestions.isEmpty {
                    ContentUnavailableView("No Suggestions", systemImage: "sparkles", description: Text("Try updating your resume with more specific skills and experience."))
                } else {
                    List(viewModel.suggestions) { job in
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
                            } else {
                                Text("Match based on your skills").font(.caption2).foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("AI Suggestions")
            .onAppear {
                viewModel.updateSuggestions(resumeContent: resumeContent)
            }
        }
    }
}
