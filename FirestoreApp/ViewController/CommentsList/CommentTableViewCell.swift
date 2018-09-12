import UIKit
import Firebase

protocol CommentTableViewCellDelegate: class {
    func didTapOptionsMenu(of comment: Comment)
}

final class CommentTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var timeStampLabel: UILabel!
    @IBOutlet private weak var commentTextLabel: UILabel!
    @IBOutlet private weak var optionsMenuLabel: UILabel!
    
    // Variables
    private var comment: Comment!
    private var delegate: CommentTableViewCellDelegate?
    
    // LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// Private method
extension CommentTableViewCell {
    func configureCell(comment: Comment, delegate: CommentTableViewCellDelegate) {
        self.comment = comment
        self.delegate = delegate
        
        selectionStyle = .none
        optionsMenuLabel.isHidden = true
        
        userNameLabel.text = comment.userName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: comment.timeStamp)
        timeStampLabel.text = timestamp
        
        commentTextLabel.text = comment.commentText
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionsMenuLabel.isHidden = false
            optionsMenuLabel.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOptionsMenu))
            optionsMenuLabel.addGestureRecognizer(tapGestureRecognizer)
        }
    }
}

// Action method
extension CommentTableViewCell {
    @objc func didTapOptionsMenu(sender: UITapGestureRecognizer) {
        delegate?.didTapOptionsMenu(of: comment)
    }
}
