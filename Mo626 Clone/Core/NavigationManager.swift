//
//  NavigationManager.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 06/01/2026.
//

import SwiftUI

@Observable
class NavigationManager {
    static let shared = NavigationManager()

    private init() {

    }

    var path = NavigationPath()
}


