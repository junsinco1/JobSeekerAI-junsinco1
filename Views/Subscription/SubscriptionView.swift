import SwiftUI

struct SubscriptionView: View {
    @State private var isTrialActive = true
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Premium Features")
                .font(.largeTitle)
                .bold()
            
            Text("Unlock AI-powered resume tailoring and job suggestions with our premium subscription.")
                .multilineTextAlignment(.center)
                .padding()
            
            if isTrialActive {
                Text("Trial Active: 5 Days Remaining")
                    .foregroundColor(.green)
            } else {
                Button("Subscribe Now") {
                    // Handle subscription
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

