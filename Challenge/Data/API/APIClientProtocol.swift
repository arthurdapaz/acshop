import Foundation
import class UIKit.UIImage

protocol APIClientProtocol {
    func fetchProducts() async throws -> [Product]
    func fetchImage(from imageURL: URL) async throws -> UIImage
}
