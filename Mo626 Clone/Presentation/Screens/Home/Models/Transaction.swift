//
//  Transaction.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 24/12/2025.
//

import Foundation

struct Transaction: Identifiable {
    let id = UUID()  // Required for ForEach
    let title: String
    let amount: Double
    let date: String
    let type: TransactionType
    
    enum TransactionType {
        case debit
        case credit
    }
}
