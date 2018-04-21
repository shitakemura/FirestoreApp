
import Foundation
import Firebase

class Notice {
    private(set) var userName: String
    private(set) var timeStamp: Date
    private(set) var noticeText: String
    private(set) var numLikes: Int
    private(set) var numComments: Int
    private(set) var documentId: String
    private(set) var userId: String
    
    init(userName: String, timeStamp: Date, noticeText: String, numLikes: Int, numComments: Int, documentId: String, userId: String) {
        self.userName = userName
        self.timeStamp = timeStamp
        self.noticeText = noticeText
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
        self.userId = userId
    }
    
    static func parse(snapshot: QuerySnapshot) -> [Notice] {
        let notices = snapshot.documents.map { document -> Notice in
            let userName = document[FirestoreDocument.username.key] as? String ?? ""
            let timeStamp = document[FirestoreDocument.timestamp.key] as? Date ?? Date()
            let noticeText = document[FirestoreDocument.noticeText.key] as? String ?? ""
            let numLikes = document[FirestoreDocument.numLikes.key] as? Int ?? 0
            let numComments = document[FirestoreDocument.numComments.key] as? Int ?? 0
            let documentId = document.documentID
            let userId = document[FirestoreDocument.userId.key] as? String ?? ""

            return Notice(userName: userName, timeStamp: timeStamp, noticeText: noticeText, numLikes: numLikes, numComments: numComments, documentId: documentId, userId: userId)
        }
        return notices
    }
}
