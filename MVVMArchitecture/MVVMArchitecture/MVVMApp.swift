//
//  MVVMApp.swift
//  MVVMArchitecture
//
//  Created by Tejora on 05/02/20.
//  Copyright © 2020 Tejora. All rights reserved.
//

import UIKit

final class MVVMApp {
    static let appInstance = MVVMApp()
    let networkClient : NetworkClient!
    private init() {
        networkClient = NetworkClient()
    }
}
