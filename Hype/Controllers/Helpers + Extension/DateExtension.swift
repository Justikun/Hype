//
//  DateExtension.swift
//  Hype
//
//  Created by Justin Lowry on 1/10/22.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
