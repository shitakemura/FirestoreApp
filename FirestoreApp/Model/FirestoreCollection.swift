
import Foundation

enum FirestoreCollection {
    case notices
    case users
    case comments
    
    var key: String {
        return String(describing: self)
    }
}

enum FirestoreDocument {
    case category
    case numComments
    case numLikes
    case noticeText
    case timestamp
    case userId
    case username
    case documentId
    case dateCreated
    case commentText
    
    var key: String {
        return String(describing: self)
    }
}
