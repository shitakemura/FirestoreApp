
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
    
    // Variables
    private var notice: Notice!
    
    // LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLike()
    }
}

extension NoticeTableViewCell {
    func setupLike() {
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

extension NoticeTableViewCell {
    @objc func didTapLike() {
        Firestore.firestore()
            .collection(String(describing: FirestoreCollection.notices))
            .document(notice.documentId)
            .setData([String(describing: FirestoreDocument.numLikes): notice.numLikes + 1], options: SetOptions.merge())
    }
}
