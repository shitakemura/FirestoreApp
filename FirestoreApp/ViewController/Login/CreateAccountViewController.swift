
import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
}

extension CreateAccountViewController {
    func setupButton() {
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        createAccountButton.layer.cornerRadius = 4.0
        cancelButton.layer.cornerRadius = 4.0
    }
}

extension CreateAccountViewController {
    @objc func didTapCreateAccount(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let userName = userNameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error creating user: \(error.localizedDescription)")
            }
            
            let changeRequest = user?.createProfileChangeRequest()
            changeRequest?.displayName = userName
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })
            
            guard let userId = user?.uid else { return }
            Firestore.firestore()
                .collection(String(describing: FirestoreCollection.users))
                .document(userId)
                .setData([
                    String(describing: FirestoreDocument.username): userName,
                    String(describing: FirestoreDocument.dateCreated): FieldValue.serverTimestamp()
                ], completion: { (error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
        }
    }
    
    @objc func didTapCancel(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
