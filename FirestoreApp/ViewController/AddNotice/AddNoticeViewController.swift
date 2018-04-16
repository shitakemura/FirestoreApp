
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
    private var selectedCategory = AddNoticeCategory.tweet.name
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupSegmentedControl()
        setupTextView()
    }
}

extension AddNoticeViewController {
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
}

extension AddNoticeViewController {
    @objc func didTapClose(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapPost(sender: UIButton) {
        guard let userName = userNameTextField.text else { return }
        
        Firestore.firestore()
            .collection(String(describing: FirestoreCollection.notices))
            .addDocument(data: [
                String(describing: FirestoreDocument.category): selectedCategory,
                String(describing: FirestoreDocument.numComments): 0,
                String(describing: FirestoreDocument.numLikes): 0,
                String(describing: FirestoreDocument.noticeText): noticeTextView.text,
                String(describing: FirestoreDocument.timestamp): FieldValue.serverTimestamp(),
                String(describing: FirestoreDocument.username): userName,
            ]) { (error) in
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

extension AddNoticeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        noticeTextView.text = ""
    }
}

