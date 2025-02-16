
import UIKit

public extension UICollectionView {
    func registerReusableNibCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerReusableSupplementaryView<T: UICollectionReusableView>(_ T: T.Type,
                                                                        forSupplementaryViewOfKind kind: String)
        where T: Reusable {
            register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func safeReloadData() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

// MARK: - Safe Execute

extension UICollectionView {
    func safeSelectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        guard let indexPath = indexPath else { return }
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfItems(inSection: indexPath.section) else { return }
        selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
    }
}
