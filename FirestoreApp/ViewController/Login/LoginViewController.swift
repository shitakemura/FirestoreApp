
import UIKit
import Firebase

class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        
    }
}

extension LoginViewController {
    func setupButton() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.layer.cornerRadius = 4.0
        createAccountButton.layer.cornerRadius = 4.0
    }
}

extension LoginViewController {
    @objc func didTapLogin(sender: UIButton) {
        
    }
    
    @objc func didTapCreateAccount(sender: UIButton) {
        let signUpViewController = SignUpViewController()
        present(signUpViewController, animated: true, completion: nil)
    }
}
