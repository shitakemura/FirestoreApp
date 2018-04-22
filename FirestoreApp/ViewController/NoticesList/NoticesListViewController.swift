
import UIKit
import Firebase

enum NoticesListCategory: Int {
    case tweet = 0
    case notification = 1
    case request = 2
    case favorite = 3
    
    var name: String {
        switch self {
        case .tweet:            return "ひとりごと"
        case .notification:     return "お知らせ"
        case .request:          return "お願い"
        case .favorite:         return "⭐️"
        }
    }
}

class NoticesListViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // Variables
    private var notices = [Notice]()
    private var collectionReference: CollectionReference!
    private var listenerRegistration: ListenerRegistration!
    private var selectedCategory = NoticesListCategory.tweet.name
    private var listenerHandle: AuthStateDidChangeListenerHandle?
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupSegmentedControl()
        setupTableView()
        collectionReference = Firestore.firestore()
            .collection(FirestoreCollection.notices.key)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let loginViewController = LoginViewController()
                self.present(loginViewController, animated: true, completion: nil)
            } else {
                self.setupListenerRegistration()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if listenerRegistration != nil {
            listenerRegistration.remove()
        }
    }
}

// Private method
private extension NoticesListViewController {
    func setupNavigation() {
        title = "連絡帳"
        let logoutButton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(didTapLogout))
        navigationItem.leftBarButtonItem = logoutButton
        
        let addButton = UIBarButtonItem(image: UIImage(named: "addThoughtIcon"), style: .plain, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItem = addButton
    }

    func setupSegmentedControl() {
        categorySegmentedControl.addTarget(self, action: #selector(didChangeCategory), for: .valueChanged)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeTableViewCell")
    }

    func setupListenerRegistration() {
        
//        if selectedCategory == String(describing: NoticesListCategory.favorite) {
//            
//        }
        
        listenerRegistration = collectionReference
            .whereField(FirestoreDocument.category.key, isEqualTo: selectedCategory)
            .order(by: FirestoreDocument.timestamp.key, descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    debugPrint("Error fetching docs: \(error.localizedDescription)")
                } else {
                    self.notices.removeAll()
                    guard let snapshot = snapshot else { return }
                    self.notices = Notice.parse(snapshot: snapshot)
                    self.tableView.reloadData()
                }
        }
    }
}

// Action method
private extension NoticesListViewController {
    @objc func didTapLogout(sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            debugPrint("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    @objc func didTapAdd(sender: UIBarButtonItem) {
        let addNoticeViewController = AddNoticeViewController()
        present(addNoticeViewController, animated: true, completion: nil)
    }
    
    @objc func didChangeCategory(sender: UISegmentedControl) {
        let selectedIndex = categorySegmentedControl.selectedSegmentIndex
        guard let noticesListCategory = NoticesListCategory(rawValue: selectedIndex) else { return }
        selectedCategory = noticesListCategory.name
        
        listenerRegistration.remove()
        setupListenerRegistration()
    }
}

// UITableViewDelegate
extension NoticesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentsListViewController = CommentsListViewController(notice: notices[indexPath.row])
        navigationController?.pushViewController(commentsListViewController, animated: true)
    }
}

// UITableViewDataSource
extension NoticesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(notice: notices[indexPath.row], delegate: self)
        return cell
    }
}

// NoticeTableViewCellDelegate
extension NoticesListViewController: NoticeTableViewCellDelegate {
    func didTapOptionsMenu(of notice: Notice) {
        let actionSheet = UIAlertController(title: "連絡事項", message: "削除しますか？", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除", style: .default) { (action) in
                    
            // TODO: - delete subcollection(comment)
            
            Firestore.firestore()
                .collection(FirestoreCollection.notices.key)
                .document(notice.documentId)
                .delete(completion: { (error) in
                    if let error = error {
                        debugPrint("unable to delete notice: \(error.localizedDescription)")
                    } else {
                        actionSheet.dismiss(animated: true, completion: nil)
                    }
                })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}

