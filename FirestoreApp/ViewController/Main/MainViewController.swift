
import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
    }
}

extension MainViewController {
    func setupNavigation() {
        title = "連絡"
        let addButton = UIBarButtonItem(image: UIImage(named: "addThoughtIcon"), style: .plain, target: self, action: #selector(didTapAddButton))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func didTapAddButton(sender: UIBarButtonItem) {
        let addNoticeViewController = AddNoticeViewController()
        present(addNoticeViewController, animated: true, completion: nil)
    }
}
