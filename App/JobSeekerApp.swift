@main
import SwiftUI
import SwiftData

@main
struct JobSeekerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Job.self, Resume.self, Subscription.self])
    }
}

