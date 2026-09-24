import SwiftUI
import SwiftData

struct JobDetailView: View {
    let job: Job
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(job.title)
                    .font(.largeTitle)
                    .bold()
                
                Text(job.company)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text("Description")
                    .font(.headline)
                Text(job.description)
                    .font(.body)
                
                Text("Requirements")
                    .font(.headline)
                Text(job.requirements)
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
