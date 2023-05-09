import UIKit

extension UIImageView {
    private static let cache = NSCache<NSString, UIImage>()

    @MainActor
    func setImageFrom(url: URL) async throws {
        let cacheKey = url.absoluteString as NSString

        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        if let image = UIImage(data: data) {
            Self.cache.setObject(image, forKey: cacheKey)
            self.image = image
        } else {
            throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
        }
    }
}
