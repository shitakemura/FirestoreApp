
import UIKit
import Firebase

enum AddNoticeCategory: Int {
    case tweet = 0
    case notification = 1
    case request = 2
    
    var name: String {
        switch self {
        case .tweet:            return "ひとりごと"
        case .notification:     return "お知らせ"
        case .request:          return "お願い"
        }
    }
}

class AddNoticeViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var noticeTextView: UITextView!
    @IBOutlet private weak var postButton: UIButton!
    
    // Variables
    private var activityIndicator: UIActivityIndicatorView!
    private var selectedCategory = AddNoticeCategory.tweet.name
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupSegmentedControl()
        setupTextView()
        setupActivityIndicator()
    }
}

// Private method
private extension AddNoticeViewController {
    func setupButton() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        postButton.layer.cornerRadius = 4
    }
    
    func setupSegmentedControl() {
        categorySegmentedControl.addTarget(self, action: #selector(didChangeCategory), for: .valueChanged)
    }
    
    func setupTextView() {
        noticeTextView.text = "連絡事項を入力してください。"
        noticeTextView.delegate = self
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
}

// Action method
private extension AddNoticeViewController {
    @objc func didTapClose(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapPost(sender: UIButton) {
        guard let userName = userNameTextField.text else { return }
        
        activityIndicator.startAnimating()
        Firestore.firestore()
            .collection(FirestoreCollection.notices.key)
            .addDocument(data: [
                FirestoreDocument.category.key: selectedCategory,
                FirestoreDocument.numComments.key: 0,
                FirestoreDocument.numLikes.key: 0,
                FirestoreDocument.noticeText.key: noticeTextView.text,
                FirestoreDocument.timestamp.key: FieldValue.serverTimestamp(),
                FirestoreDocument.username.key: userName,
                FirestoreDocument.userId.key: Auth.auth().currentUser?.uid ?? ""
            ]) { (error) in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    debugPrint("Error adding document: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    @objc func didChangeCategory(sender: UISegmentedControl) {
        let selectedIndex = categorySegmentedControl.selectedSegmentIndex
        guard let addNoticeCategory = AddNoticeCategory(rawValue: selectedIndex) else { return }
        selectedCategory = addNoticeCategory.name
    }
}

// UITextViewDelegate
extension AddNoticeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        noticeTextView.text = ""
    }
}
