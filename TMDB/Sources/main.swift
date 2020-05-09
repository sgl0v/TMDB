//
//  main.swift
//  TMDB
//
//  Created by Maksym Shcheglov on 08/05/2020.
//  Copyright © 2020 Maksym Shcheglov. All rights reserved.
//

import UIKit

private let unitTestAppDelegateClass: AnyClass? = NSClassFromString("TMDBTests.FakeAppDelegate")
private let appDelegateClass: AnyClass = unitTestAppDelegateClass ?? AppDelegate.self

_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
