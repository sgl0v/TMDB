//
//  ImageCache.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 06/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

// Declares in-memory image cache
protocol ImageCacheType: class {
    // Returns the image associated with a given url
    func image(for url: URL) -> UIImage?
    // Inserts the image of the specified url in the cache
    func insertImage(_ image: UIImage?, for url: URL)
    // Removes the image of the specified url in the cache
    func removeImage(for url: URL)
    // Removes all images from the cache
    func removeAllImages()
    // Accesses the value associated with the given key for reading and writing
    subscript(_ url: URL) -> UIImage? { get set }
}

class ImageCache: ImageCacheType {

    // 1st level cache, that contains decoded images
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = countLimit
        return cache
    }()
    // 2nd level cache, that contains raw images
    private lazy var decompressedImageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = memoryLimit
        return cache
    }()
    private let lock = NSLock()
    private let countLimit: Int
    private let memoryLimit: Int

    private enum Constants {
        static let defaultCountLimit = 100
        static let defaultMemoryLimit = 1024 * 1024 * 100 // 100 MB
    }

    init(countLimit: Int = Constants.defaultCountLimit, memoryLimit: Int = Constants.defaultMemoryLimit) {
        self.countLimit = countLimit
        self.memoryLimit = memoryLimit
    }

    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decompressed image in memory
        if let decompressedImage = decompressedImageCache.object(forKey: url as AnyObject) as? UIImage {
            return decompressedImage
        }
        // search for raw image data
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            let decompressedImage = image.decompressed()
            decompressedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
            return decompressedImage
        }
        return nil
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        lock.lock(); defer { lock.unlock() }
        guard let image = image else { return removeImage(for: url) }

        let decompressedImage = image.decompressed()
        imageCache.setObject(decompressedImage, forKey: url as AnyObject, cost: 1)
        decompressedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
    }

    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
        decompressedImageCache.removeObject(forKey: url as AnyObject)
    }

    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
        decompressedImageCache.removeAllObjects()
    }

    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}

fileprivate extension UIImage {
    func decompressed() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        self.draw(at: CGPoint.zero)
        UIGraphicsEndImageContext()
        return self
    }

    // Rough estimation of how much memory image uses in bytes
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
}
