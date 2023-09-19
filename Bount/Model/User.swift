import Foundation
import FirebaseFirestoreSwift

struct User : Identifiable, Codable {
    @DocumentID var id: String?
    
    var firstName: String
    var lastName: String
    var email: String
    @ServerTimestamp var joined: Date?
}
