
import Foundation
import Firebase

class Notice {
    private(set) var userName: String
    private(set) var timeStamp: Date
    private(set) var noticeText: String
    private(set) var numLikes: Int
    private(set) var numComments: Int
    private(set) var documentId: String
    
    init(userName: String, timeStamp: Date, noticeText: String, numLikes: Int, numComments: Int, documentId: String) {
        self.userName = userName
        self.timeStamp = timeStamp
        self.noticeText = noticeText
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
    }
    
    static func parse(snapshot: QuerySnapshot) -> [Notice] {
//        var notices = [Notice]()
//        for document in snapshot.documents {
//            let userName = document[String(describing: FirestoreDocument.username)] as? String ?? ""
//            let timeStamp = document[String(describing: FirestoreDocument.timestamp)] as? Date ?? Date()
//            let noticeText = document[String(describing: FirestoreDocument.noticeText)] as? String ?? ""
//            let numLikes = document[String(describing: FirestoreDocument.numLikes)] as? Int ?? 0
//            let numComments = document[String(describing: FirestoreDocument.numComments)] as? Int ?? 0
//            let documentId = document[String(describing: FirestoreDocument.documentId)] as? String ?? ""
//
//            let notice = Notice(userName: userName, timeStamp: timeStamp, noticeText: noticeText, numLikes: numLikes, numComments: numComments, documentId: documentId)
//
//            notices.append(notice)
//        }
//        return notices
        
        let notices = snapshot.documents.map { document -> Notice in
            let userName = document[String(describing: FirestoreDocument.username)] as? String ?? ""
            let timeStamp = document[String(describing: FirestoreDocument.timestamp)] as? Date ?? Date()
            let noticeText = document[String(describing: FirestoreDocument.noticeText)] as? String ?? ""
            let numLikes = document[String(describing: FirestoreDocument.numLikes)] as? Int ?? 0
            let numComments = document[String(describing: FirestoreDocument.numComments)] as? Int ?? 0
            let documentId = document[String(describing: FirestoreDocument.documentId)] as? String ?? ""

            return Notice(userName: userName, timeStamp: timeStamp, noticeText: noticeText, numLikes: numLikes, numComments: numComments, documentId: documentId)
        }
        return notices
    }
}
