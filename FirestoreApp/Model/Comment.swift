
import Foundation
import Firebase

class Comment {
    private(set) var userName: String
    private(set) var timeStamp: Date
    private(set) var commentText: String
    
    init(userName: String, timeStamp: Date, commentText: String) {
        self.userName = userName
        self.timeStamp = timeStamp
        self.commentText = commentText
    }
    
    static func parse(snapshot: QuerySnapshot) -> [Comment] {
        let comments = snapshot.documents.map { comment -> Comment in
            let userName = comment[String(describing: FirestoreDocument.username)] as? String ?? ""
            let timeStamp = comment[String(describing: FirestoreDocument.timestamp)] as? Date ?? Date()
            let commentText = comment[String(describing: FirestoreDocument.commentText)] as? String ?? ""

            return Comment(userName: userName, timeStamp: timeStamp, commentText: commentText)
        }
        return comments
    }
}

