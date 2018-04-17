
import UIKit

class CommentsListViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTextField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    
    // Variables
    private var notice: Notice!
    
    // Initializer
    init(notice: Notice) {
        self.notice = notice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
}

extension CommentsListViewController {
    func setupButton() {
        addCommentButton.addTarget(self, action: #selector(didTapAddComment), for: .touchUpInside)
    }
}

extension CommentsListViewController {
    @objc func didTapAddComment(sender: UIButton) {
        
    }
}
