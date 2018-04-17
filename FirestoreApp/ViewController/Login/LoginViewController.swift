
import UIKit
import Firebase

class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    // Variables
    private var activityIndicator: UIActivityIndicatorView!
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
        setupActivityIndicator()
    }
}

extension LoginViewController {
    func setupButton() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        loginButton.layer.cornerRadius = 4.0
        createAccountButton.layer.cornerRadius = 4.0
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }
}

extension LoginViewController {
    @objc func didTapLogin(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                debugPrint("Error signing in: \(error)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapCreateAccount(sender: UIButton) {
        let signUpViewController = CreateAccountViewController()
        present(signUpViewController, animated: true, completion: nil)
    }
}
