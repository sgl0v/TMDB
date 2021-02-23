//
//  FlowCoordinator.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 02/10/2019.
//  Copyright © 2019 Maksym Shcheglov. All rights reserved.
//

import UIKit

/// A `FlowCoordinator` takes responsibility about coordinating view controllers and driving the flow in the application.
protocol FlowCoordinator: AnyObject {

    /// Stars the flow
    func start()
}

