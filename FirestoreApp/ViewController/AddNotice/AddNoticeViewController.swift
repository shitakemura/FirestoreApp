
import UIKit

class AddNoticeViewController: UIViewController {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var noticeTextView: UITextView!
    @IBOutlet private weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupSegmentedControl()
        setupTextView()
    }
}

extension AddNoticeViewController {
    func setupButton() {
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
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
    @objc func didTapCloseButton(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func didTapPostButton(sender: UIButton) {
        
    }
    
    @objc func didChangeCategory(sender: UISegmentedControl) {
        print("category changed")
    }
}

extension AddNoticeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        noticeTextView.text = ""
    }
}

