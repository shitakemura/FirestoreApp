import UIKit
import Firebase

protocol NoticeTableViewCellDelegate: class {
    func didTapOptionsMenu(of notice: Notice)
}

final class NoticeTableViewCell: UITableViewCell {
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
    private var delegate: NoticeTableViewCellDelegate?
    
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
    
    func configureCell(notice: Notice, delegate: NoticeTableViewCellDelegate) {
        self.notice = notice
        self.delegate = delegate
        
        optionsMenuLabel.isHidden = true
        userNameLabel.text = notice.userName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: notice.timeStamp)
        timeStampLabel.text = timestamp
        
        noticeTextLabel.text = notice.noticeText
        numLikesLabel.text = notice.numLikes.description
        numCommentsLabel.text = notice.numComments.description
        
        if notice.userId == Auth.auth().currentUser?.uid {
            optionsMenuLabel.isHidden = false
            optionsMenuLabel.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOptionsMenu))
            optionsMenuLabel.addGestureRecognizer(tapGestureRecognizer)
        }
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
    
    @objc func didTapOptionsMenu(sender: UITapGestureRecognizer) {
        delegate?.didTapOptionsMenu(of: notice)
    }
}
