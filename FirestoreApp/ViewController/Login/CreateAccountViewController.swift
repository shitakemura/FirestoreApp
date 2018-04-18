
import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var userNameTextField: UITextField!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Variables
    private var activityIndicator: UIActivityIndicatorView!
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupActivityIndicator()
    }
}

// Private method
private extension CreateAccountViewController {
    func setupButton() {
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        createAccountButton.layer.cornerRadius = 4.0
        cancelButton.layer.cornerRadius = 4.0
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
}

// Action method
private extension CreateAccountViewController {
    @objc func didTapCreateAccount(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let userName = userNameTextField.text else { return }
        
        activityIndicator.startAnimating()
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.activityIndicator.stopAnimating()
                debugPrint("Error creating user: \(error.localizedDescription)")
                return
            }
            
            let changeRequest = user?.createProfileChangeRequest()
            changeRequest?.displayName = userName
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    debugPrint(error.localizedDescription)
                    return
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
                    self.activityIndicator.stopAnimating()
                })
        }
    }
    
    @objc func didTapCancel(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
