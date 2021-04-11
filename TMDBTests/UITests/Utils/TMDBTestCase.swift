//
//  XCTestCase+Utils.swift
//  TMDBTests
//
//  Created by Maksym Shcheglov on 10/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import XCTest
import EarlGrey
@testable import TMDB

class TMDBTestCase: XCTestCase {
    
    lazy var factory = ApplicationComponentsFactory(servicesProvider: ServicesProvider(network: networkService, imageLoader: imageLoader))
    lazy var networkService = NetworkServiceTypeMock()
    lazy var imageLoader: ImageLoaderServiceType = {
        let mock = ImageLoaderServiceTypeMock()
        mock.loadImageFromClosure = { _ in
            let image = UIImage(named: "joker.jpg", in: Bundle(for: EarlGrey.self), compatibleWith: nil)
            return .just(image)
        }
        return mock
    }()

    override func setUp() {
        setupEarlGrey()
    }
    
    private func setupEarlGrey() {
        GREYConfiguration.sharedInstance().setValue(false, forConfigKey: kGREYConfigKeyAnalyticsEnabled) // Disable Google analytics tracking
        GREYConfiguration.sharedInstance().setValue(5.0, forConfigKey: kGREYConfigKeyInteractionTimeoutDuration) // use 5s timeout for any interaction
        GREYTestHelper.enableFastAnimation() // increase the speed of your tests by not having to wait on slow animations.
    }
    
    struct OpenViewControllerFlags: OptionSet {
        let rawValue: Int
        
        static let presentModally = OpenViewControllerFlags(rawValue: 1 << 0)
        static let embedInNavigation = OpenViewControllerFlags(rawValue: 1 << 1)
        static let all: OpenViewControllerFlags = [.presentModally, .embedInNavigation]
    }
    
    func open(viewController: UIViewController, flags: OpenViewControllerFlags = .presentModally) {
        let viewControllerToOpen = flags.contains(.embedInNavigation) ? UINavigationController(rootViewController: viewController) : viewController
        viewControllerToOpen.modalPresentationStyle = .fullScreen
        let window = (UIApplication.shared.delegate as! FakeAppDelegate).window!
        
        if flags.contains(.presentModally) {
            window.rootViewController = UIViewController()
            window.rootViewController?.present(viewControllerToOpen, animated: false, completion: nil)
        } else {
            window.rootViewController = viewControllerToOpen
        }
    }
}

extension Decodable {
    static func loadFromFile(_ filename: String) -> Self {
        do {
            let path = Bundle(for: EarlGrey.self).path(forResource: filename, ofType: nil)!
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return try JSONDecoder().decode(Self.self, from: data)
        } catch {
            fatalError("Error: \(error)")
        }
    }
}
