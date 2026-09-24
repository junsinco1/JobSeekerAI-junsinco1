import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        MainTabView(modelContext: modelContext)
    }
}
