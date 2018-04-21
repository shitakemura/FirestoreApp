
import UIKit
import Firebase

class NoticeTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var timeStampLabel: UILabel!
    @IBOutlet private weak var noticeTextLabel: UILabel!
    @IBOutlet private weak var likesImageLabel: UILabel!
    @IBOutlet private weak var numLikesLabel: UILabel!
    @IBOutlet private weak var commentsImageLabel: UILabel!
    @IBOutlet private weak var numCommentsLabel: UILabel!
    @IBOutlet private weak var optionsMenuLabel: UILabel!
    
    // Variables
    private var notice: Notice!
    
    // LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLike()
    }
}

// Private method
extension NoticeTableViewCell {
    private func setupLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLike))
        likesImageLabel.addGestureRecognizer(tap)
        likesImageLabel.isUserInteractionEnabled = true
    }
    
    func configureCell(notice: Notice) {
        self.notice = notice
        userNameLabel.text = notice.userName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: notice.timeStamp)
        timeStampLabel.text = timestamp
        
        noticeTextLabel.text = notice.noticeText
        numLikesLabel.text = notice.numLikes.description
        numCommentsLabel.text = notice.numComments.description
    }
}

// Action method
private extension NoticeTableViewCell {
    @objc func didTapLike() {
        Firestore.firestore()
            .collection(FirestoreCollection.notices.key)
            .document(notice.documentId)
            .setData([FirestoreDocument.numLikes.key: notice.numLikes + 1], options: SetOptions.merge())
    }
}
