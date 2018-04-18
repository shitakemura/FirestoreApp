
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
    private var documentReference: DocumentReference
    private var userName: String?
    private var listenerRegistration: ListenerRegistration!
    private var activityIndicator: UIActivityIndicatorView!
    
    // Initializer
    init(notice: Notice) {
        self.notice = notice
        documentReference = Firestore.firestore()
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
        setupActivityIndicator()
        
        guard let name = Auth.auth().currentUser?.displayName else { return }
        userName = name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupListenerRegistration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if listenerRegistration != nil {
            listenerRegistration.remove()
        }
    }
}

// Private method
private extension CommentsListViewController {
    func setupNavigation() {
        title = notice.noticeText
    }
    
    func setupButton() {
        addCommentButton.addTarget(self, action: #selector(didTapAddComment), for: .touchUpInside)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
    
    func setupListenerRegistration() {
        listenerRegistration = documentReference
            .collection(String(describing: FirestoreCollection.comments))
            .order(by: String(describing: FirestoreDocument.timestamp), descending: false)
            .addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else {
                debugPrint("Error fetching comment: \(String(describing: error))")
                return
            }
            
            self.comments.removeAll()
            self.comments = Comment.parse(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
}

// Action method
private extension CommentsListViewController {
    @objc func didTapAddComment(sender: UIButton) {
        guard let commentText = addCommentTextField.text else { return }
        
        activityIndicator.startAnimating()
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            
            let selectedNoticeDocument: DocumentSnapshot
            
            do {
                try selectedNoticeDocument = transaction.getDocument(self.documentReference)

            } catch let error as NSError {
                self.activityIndicator.stopAnimating()
                debugPrint("Fetch error: \(error.localizedDescription)")
                return nil
            }
            
            guard let numComments = selectedNoticeDocument.data()[String(describing: FirestoreDocument.numComments)] as? Int else { return nil }
            
            transaction.updateData([String(describing: FirestoreDocument.numComments) : numComments + 1], forDocument: self.documentReference)
            
            let addCommentReference = self.documentReference.collection(String(describing: FirestoreCollection.comments)).document()
            
            transaction.setData([
                String(describing: FirestoreDocument.commentText) : commentText,
                String(describing: FirestoreDocument.timestamp): FieldValue.serverTimestamp(),
                String(describing: FirestoreDocument.username): self.userName?.description ?? ""
                ], forDocument: addCommentReference)
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error.localizedDescription)")
            } else {
                self.addCommentTextField.text = ""
            }
            self.activityIndicator.stopAnimating()
        }
    }
}

// UITableViewDataSource
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
