
import UIKit

class CommentTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var timeStampLabel: UILabel!
    @IBOutlet private weak var commentTextLabel: UILabel!
    
    // LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// Private method
extension CommentTableViewCell {
    func configureCell(comment: Comment) {
        selectionStyle = .none
        
        userNameLabel.text = comment.userName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, hh:mm"
        let timestamp = formatter.string(from: comment.timeStamp)
        timeStampLabel.text = timestamp
        
        commentTextLabel.text = comment.commentText
    }
}
