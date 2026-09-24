import Foundation
import SwiftData

@Model
class Resume {
    @Attribute(.unique) var id: UUID
    var name: String
    var content: String // Main content of the resume
    var lastUpdated: Date
    var is_temporary: Bool
    var target_job_id: UUID? // For temporary resumes tailored to a job
    var tailoredContent: String? // AI generated tailored content
    
    init(id: UUID = UUID(), name: String, content: String, lastUpdated: Date = Date(), is_temporary: Bool = false, target_job_id: UUID? = nil, tailoredContent: String? = nil) {
        self.id = id
        self.name = name
        self.content = content
        self.lastUpdated = lastUpdated
        self.is_temporary = is_temporary
        self.target_job_id = target_job_id
        self.tailoredContent = tailoredContent
    }
}
