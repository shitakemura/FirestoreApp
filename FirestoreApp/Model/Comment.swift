
import Foundation
import Firebase

class Comment {
    private(set) var userName: String
    private(set) var timeStamp: Date
    private(set) var commentText: String
    private(set) var documentId: String
    private(set) var userId: String
    
    init(userName: String, timeStamp: Date, commentText: String, documentId: String, userId: String) {
        self.userName = userName
        self.timeStamp = timeStamp
        self.commentText = commentText
        self.documentId = documentId
        self.userId = userId
    }
    
    static func parse(snapshot: QuerySnapshot) -> [Comment] {
        let comments = snapshot.documents.map { comment -> Comment in
            let userName = comment[FirestoreDocument.username.key] as? String ?? ""
            let timeStamp = comment[FirestoreDocument.timestamp.key] as? Date ?? Date()
            let commentText = comment[FirestoreDocument.commentText.key] as? String ?? ""
            let documentId = comment.documentID
            let userId = comment[FirestoreDocument.userId.key] as? String ?? ""

            return Comment(userName: userName, timeStamp: timeStamp, commentText: commentText, documentId: documentId, userId: userId)
        }
        return comments
    }
}

