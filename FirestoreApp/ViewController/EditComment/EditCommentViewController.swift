import UIKit
import Firebase

final class EditCommentViewController: UIViewController {
    // Outlets
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    // Variables
    private let notice: Notice
    private let comment: Comment
    
    init(notice: Notice, comment: Comment) {
        self.notice = notice
        self.comment = comment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButton()
        setupTextView()
    }
}

// Private method
private extension EditCommentViewController {
    func setupNavigation() {
        title = "コメント編集"
    }
    
    func setupButton() {
        updateButton.layer.cornerRadius = 4
        updateButton.addTarget(self, action: #selector(didTapUpdate), for: .touchUpInside)
    }
    
    func setupTextView() {
        commentTextView.text = comment.commentText
    }
}

// Action method
extension EditCommentViewController {
    @objc func didTapUpdate(sender: UIButton) {
        Firestore.firestore()
            .collection(FirestoreCollection.notices.key)
            .document(notice.documentId)
            .collection(FirestoreCollection.comments.key)
            .document(comment.documentId)
            .updateData([FirestoreDocument.commentText.key : commentTextView.text]) { (error) in
                if let error = error {
                    debugPrint("unable to update comment: \(error.localizedDescription)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
        }
    }
}
