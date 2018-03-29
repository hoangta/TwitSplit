import UIKit

extension UIStoryboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

//IMPORTANT: Remember to add storyboard ID using the UIViewController type.
extension UIStoryboard {
    func controller<UIViewController>(_ type: UIViewController.Type) -> UIViewController {
        return instantiateViewController(withIdentifier: String(describing: type)) as! UIViewController
    }
}

