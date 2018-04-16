
import UIKit

class NoticeTableViewCell: UITableViewCell {
    // Outlets
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var timeStampLabel: UILabel!
    @IBOutlet private weak var noticeTextLabel: UILabel!
    @IBOutlet private weak var likesImageLabel: UILabel!
    @IBOutlet private weak var numLikesLabel: UILabel!
    
    // LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(notice: Notice) {
        userNameLabel.text = notice.userName
        timeStampLabel.text = notice.timeStamp.description
        noticeTextLabel.text = notice.noticeText
        numLikesLabel.text = notice.numLikes.description        
    }
}
