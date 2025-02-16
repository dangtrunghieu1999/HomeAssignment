import UIKit
import Kingfisher

@MainActor
protocol ImageLoadable {
    func loadImage(into imageView: UIImageView, 
                  from urlString: String, 
                  placeholder: UIImage?)
}

@MainActor
extension ImageLoadable {
    func loadImage(into imageView: UIImageView,
                  from urlString: String,
                  placeholder: UIImage? = UIImage(systemName: "person.circle")) {
        let url = URL(string: urlString)
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage,
                .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
                .scaleFactor(UIScreen.main.scale)
            ]
        )
    }
} 
