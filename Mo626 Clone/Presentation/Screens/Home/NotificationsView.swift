//
//  NotificationsView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 16/01/2026.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24){

            HStack{
                Text("Notifications").font(.title2).bold()
                Spacer()
                Image(systemName: "xmark.circle").onTapGesture {
                    dismiss()
                }
            }


            ScrollView {
                ForEach(sampleNotifications) { notification in
                    NotificationItem(notification: notification)
                }
            }
        }.padding().padding(.top, 12)
    }
}

struct NotificationItem: View {
    var notification: Notification
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(notification.title).font(.headline)
                Spacer()
                Text(notification.timestamp.timeAgoDisplay())

                HStack{

                }.frame(width: 10, height: 10).overlay(Circle().fill(.blue))
            }

            Text(notification.message).font(.subheadline).lineLimit(2)
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 12, ).stroke(.secondary, lineWidth: 0.1)
        )
    }
}

#Preview {
    NotificationsView()
}

let sampleNotifications: [Notification] = [
    Notification(
        title: "Money Received",
        message: "You received MWK 15,000.00 from Thierry Henry",
        timestamp: Date().addingTimeInterval(-300),  // 5 minutes ago
        isRead: false,
        payload: ""
    ),

    Notification(
        title: "Payment Successful",
        message: "Your transfer of MWK 5,000.00 to Max Luna was successful",
        timestamp: Date().addingTimeInterval(-3600),  // 1 hour ago
        isRead: false,
        payload: ""
    ),

    Notification(
        title: "Security Alert",
        message: "New device logged into your account from Lilongwe",
        timestamp: Date().addingTimeInterval(-7200),  // 2 hours ago
        isRead: false,
        payload: ""
    ),

    Notification(
        title: "Limited Time Offer!",
        message:
            "Get 5% cashback on all transfers this weekend. Don't miss out!",
        timestamp: Date().addingTimeInterval(-86400),  // 1 day ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "Profile Update Required",
        message:
            "Please update your phone number to continue using all features",
        timestamp: Date().addingTimeInterval(-259200),  // 3 days ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "Card Expiring Soon",
        message: "Your debit card ending in 1234 expires in 30 days",
        timestamp: Date().addingTimeInterval(-345600),  // 4 days ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "Suspicious Activity Detected",
        message:
            "We noticed unusual activity on your account. Please review recent transactions",
        timestamp: Date().addingTimeInterval(-432000),  // 5 days ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "Monthly Statement Ready",
        message: "Your December statement is now available to download",
        timestamp: Date().addingTimeInterval(-604800),  // 1 week ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "Transaction Declined",
        message:
            "Your payment of MWK 25,000.00 was declined due to insufficient funds",
        timestamp: Date().addingTimeInterval(-1_209_600),  // 2 weeks ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "New Feature Available",
        message: "Try our new QR code payment feature for faster transactions",
        timestamp: Date().addingTimeInterval(-1_814_400),  // 3 weeks ago
        isRead: true,
        payload: ""
    ),

    Notification(
        title: "Password Changed",
        message: "Your password was successfully changed on Jan 10, 2026",
        timestamp: Date().addingTimeInterval(-2_419_200),  // 4 weeks ago
        isRead: true,
        payload: ""
    ),
]
