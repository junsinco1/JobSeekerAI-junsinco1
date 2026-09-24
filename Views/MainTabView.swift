import SwiftUI

struct MainTabView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(modelContext: modelContext)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            JobListView(modelContext: modelContext)
                .tabItem {
                    Label("Jobs", systemImage: "briefcase")
                }
                .tag(1)
            
            ResumeListView(modelContext: modelContext)
                .tabItem {
                    Label("Resume", systemImage: "doc.text")
                }
                .tag(2)
        }
    }
}
