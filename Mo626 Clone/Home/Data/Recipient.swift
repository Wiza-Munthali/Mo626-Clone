//
//  Recipient.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 06/01/2026.
//

import SwiftUI

struct Recipient: Identifiable {
    let id: UUID
    let name: String
    let accountNumber: String
    let bankName: String
    let phoneNumber: String
    let photo: String?
    var favorite: Bool = false
}
