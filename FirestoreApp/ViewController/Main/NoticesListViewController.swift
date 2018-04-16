
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
    private var noticesCollectionRef: CollectionReference!
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTableView()
        
        noticesCollectionRef = Firestore.firestore().collection(String(describing: FirestoreCollection.notices))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noticesCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("Error fetching docs: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else { return }
                self.notices = Notice.parse(snapshot: snapshot)
                self.tableView.reloadData()
            }
        }
    }
}

extension NoticesListViewController {
    func setupNavigation() {
        title = "連絡帳"
        let addButton = UIBarButtonItem(image: UIImage(named: "addThoughtIcon"), style: .plain, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeTableViewCell")
    }

}

extension NoticesListViewController {
    @objc func didTapAddButton(sender: UIBarButtonItem) {
        let addNoticeViewController = AddNoticeViewController()
        present(addNoticeViewController, animated: true, completion: nil)
    }
}

extension NoticesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NoticesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(notice: notices[indexPath.row])
        return cell
    }
}
