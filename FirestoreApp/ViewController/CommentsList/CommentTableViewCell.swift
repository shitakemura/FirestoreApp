
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
