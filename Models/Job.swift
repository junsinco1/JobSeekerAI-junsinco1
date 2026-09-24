import Foundation
import SwiftData

@Model
class Job {
    @Attribute(.unique) var id: UUID
    var title: String
    var company: String
    var location: String
    var wage: Double
    var jobType: String // full-time, part-time, per-diem, regular, temporary, contract
    var workMode: String // on-site, flex, remote
    var description: String
    var requirements: String
    var distance: Double // Distance from user's preferred location
    
    // AI Features
    var aiSuitabilityScore: Double?
    var aiSuitabilityMessage: String?
    
    init(id: UUID = UUID(), title: String, company: String, location: String, wage: Double, jobType: String, workMode: String, description: String, requirements: String, distance: Double) {
        self.id = id
        self.title = title
        self.company = company
        self.location = location
        self.wage = wage
        self.jobType = jobType
        self.workMode = workMode
        self.description = description
        self.requirements = requirements
        self.distance = distance
        self.aiSuitabilityScore = nil
        self.aiSuitabilityMessage = nil
    }
}
