import UIKit

extension UITableView {
    
    func register(_ cellClass: AnyClass...) {
        cellClass.forEach { register($0, forCellReuseIdentifier: String(describing: $0)) }
    }
    
    func dequeueReusableCell<Cell>(_ cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as! Cell
    }
}
