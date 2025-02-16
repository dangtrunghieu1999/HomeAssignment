
import Foundation
import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib? {
        return UINib(nibName: reuseIdentifier.self, bundle: nil)
    }
}
