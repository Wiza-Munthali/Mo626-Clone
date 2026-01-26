//
//  Notification.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 16/01/2026.
//

import Foundation

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timestamp: Date
    let isRead: Bool
    let payload: String?
}

// Helper extension for timestamp formatting
extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()

        // Check if within a week
        let components = calendar.dateComponents(
            [.minute, .hour, .day],
            from: self,
            to: now
        )

        guard let days = components.day else {
            return formatAsDate()
        }

        // More than a week - show date
        if days >= 7 {
            return formatAsDate()
        }

        // Today
        if calendar.isDateInToday(self) {
            if let hours = components.hour, hours == 0 {
                if let minutes = components.minute {
                    return minutes == 0 ? "Just now" : "\(minutes)m ago"
                }
            }
            return formatTimeOnly()
        }

        // Yesterday
        if calendar.isDateInYesterday(self) {
            return "Yesterday"
        }

        // Within a week - show relative
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: now)
    }

    private func formatAsDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: self)
    }

    private func formatTimeOnly() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}
