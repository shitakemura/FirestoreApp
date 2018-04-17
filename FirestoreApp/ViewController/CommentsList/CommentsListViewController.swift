
import UIKit
import Firebase

class CommentsListViewController: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentTextField: UITextField!
    @IBOutlet weak var addCommentButton: UIButton!
    
    // Variables
    private var notice: Notice!
    private var comments = [Comment]()
    private let firestore = Firestore.firestore()
    private var noticeRef: DocumentReference
    private var userName: String?
    
    // Initializer
    init(notice: Notice) {
        self.notice = notice
        noticeRef = firestore
            .collection(String(describing: FirestoreCollection.notices))
            .document(notice.documentId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupButton()
        setupTableView()
        
        guard let name = Auth.auth().currentUser?.displayName else { return }
        userName = name
    }
}

extension CommentsListViewController {
    func setupNavigation() {
        title = notice.noticeText
    }
    
    func setupButton() {
        addCommentButton.addTarget(self, action: #selector(didTapAddComment), for: .touchUpInside)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
    }
}

extension CommentsListViewController {
    @objc func didTapAddComment(sender: UIButton) {
        guard let comment = addCommentTextField.text else { return }
        
    }
}

extension CommentsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CommentsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(comment: comments[indexPath.row])
        return cell
    }
}
