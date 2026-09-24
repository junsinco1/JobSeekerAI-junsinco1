import Foundation
import SwiftData

@Model
class Subscription {
    @Attribute(.unique) var id: UUID
    var isActive: Bool
    var trialEndDate: Date
    var isPremium: Bool
    
    init(id: UUID = UUID(), isActive: Bool = false, trialEndDate: Date = Date().addingTimeInterval(5 * 86400), isPremium: Bool = false) {
        self.id = id
        self.isActive = isActive
        self.trialEndDate = trialEndDate
        self.isPremium = isPremium
    }
}
