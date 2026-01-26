//
//  HomeView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 23/12/2025.
//

import SwiftUI

enum NavigationPage: Hashable {
    case confirm
    case transfer
    case receipt
}

struct HomeView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 24) {
                    Header()
                    Card()
                    QuickActions {
                        path.append(NavigationPage.transfer)
                    }
                    LatestTransactions()
                }.padding()
            }.navigationDestination(for: NavigationPage.self) { page in
                switch page {
                case .transfer:
                    TransferView(onSend: {
                        path.append(NavigationPage.confirm)
                    }).toolbar(
                        .hidden,
                        for: .tabBar
                    )

                case .receipt:
                    ReceiptView(onBackToHome: { path = NavigationPath() })
                        .toolbar(.hidden, for: .tabBar)
                        .navigationBarBackButtonHidden()

                case .confirm:
                    ConfirmView(onConfirm: {
                        print("CONFIRMING")
                        path.append(NavigationPage.receipt)
                    })
                        .toolbar(
                            .hidden,
                            for: .tabBar
                        )
                }
            }.toolbar(.hidden)

        }
    }
}

struct Header: View {
    @State private var showHelpSheet = false
    @State private var showNotificationsSheet = false

    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image("wiza")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Welcome Back 👋")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16)).fontWeight(.medium)
                    Text("Wiza Munthali")
                        .fontWeight(.bold)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                HeaderButton(icon: "questionmark.message.fill") {
                    showHelpSheet = true
                }
                HeaderButton(icon: "bell.badge") {
                    showNotificationsSheet = true
                }.symbolEffect(
                    .wiggle.byLayer,
                    options: .repeat(.periodic(delay: 30.0))
                )
            }
        }.sheet(isPresented: $showHelpSheet) {
            HelpSheet().presentationDetents([.large])
        }.sheet(isPresented: $showNotificationsSheet){
            NotificationsView().presentationDetents([.large])
        }
    }
}

struct Card: View {
    @State private var isBalanceVisible = false
    let balance = "25,000.35"

    var masked: String {
        String(repeating: "*", count: balance.count)
    }

    var body: some View {
        VStack {
            HStack {
                Image("wiza_logo").resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)
                Spacer()
                Image("visa").resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60)

            }

            Spacer()

            VStack(alignment: .leading, spacing: 5) {
                Text("Available Balance")
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                HStack(spacing: 12) {
                    if isBalanceVisible {
                        Text("MWK \(balance)")
                            .fontWeight(.bold).foregroundStyle(.white).font(
                                .system(size: 25)
                            )
                    } else {
                        Text("MWK \(masked)")
                            .fontWeight(.bold).foregroundStyle(.white).font(
                                .system(size: 25)
                            )
                    }
                    Spacer()
                    Button(action: {
                        isBalanceVisible.toggle()
                    }) {
                        Image(
                            systemName: isBalanceVisible
                                ? "eye.slash.fill" : "eye.fill"
                        )
                        .foregroundStyle(
                            .white
                        )
                    }
                }
            }
        }.padding().frame(maxWidth: .infinity, minHeight: 220)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 18))

    }
}

struct QuickActions: View {
    @State private var showOtherActions = false

    let goToTransfer: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            QuickActionsItem(
                label: "Transfer",
                icon: "arrow.down.left.arrow.up.right"
            ) {
                goToTransfer()
            }
            QuickActionsItem(label: "Payments", icon: "receipt") {

            }
            QuickActionsItem(label: "Other", icon: "ellipsis") {
                showOtherActions = true
            }
        }.sheet(isPresented: $showOtherActions) {
            OtherActionsSheet().presentationDetents([.medium])
        }
    }
}

struct QuickActionsItem: View {
    var label: String
    var icon: String
    var onPress: () -> Void
    var body: some View {
        Button(action: onPress) {
            VStack {
                HStack {
                    Image(systemName: icon).foregroundStyle(.white).frame(
                        height: 20
                    )
                }.padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(label).font(.system(size: 15))
            }
        }.buttonStyle(.plain)
    }
}

struct OtherActionsSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                    ],
                    spacing: 20
                ) {
                    ActionGridItem(label: "Buy Airtime", icon: "phone.fill")
                    ActionGridItem(
                        label: "Cash Withdraw",
                        icon: "banknote.fill"
                    )
                    ActionGridItem(label: "Loans", icon: "creditcard.fill")
                    ActionGridItem(label: "Savings", icon: "banknote.fill")
                    ActionGridItem(
                        label: "Recipient Management",
                        icon: "person.fill.checkmark.and.xmark"
                    )
                }
                .padding()
            }
            .navigationTitle("More Actions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")

                    }
                }
            }
        }
    }
}


struct HelpSheet: View {
    @Environment(\.dismiss) var dismiss

    @State private var chatVisible: Bool = false
    @State var message: String = ""

    var body: some View {
        VStack {
            Spacer()
            HStack{
                if chatVisible{
                    HStack(spacing: 12) {
                        Button(action: {

                        }){
                            Image(systemName: "paperclip")
                        }.buttonStyle(.plain)

                        TextField(
                            "Ask anything",
                            text: $message
                        )
                        .textFieldStyle(.plain)


                    }.padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    Color.gray.opacity(0.1),
                                    lineWidth: 1
                                )
                        )
                }

                Button(action: {
                    chatVisible.toggle()
                }){
                    HStack{
                        if chatVisible{
                            Image(systemName: "paperplane.fill")
                                .padding(.horizontal, 8)
                        }else{
                            Spacer()
                            Text("Chat with Molly").foregroundStyle(.foreground)
                            Spacer()
                        }
                    }.padding(.vertical, 8)
                }.buttonStyle(.borderedProminent)
            }
        }.padding()
    }
}



struct ActionGridItem: View {
    var label: String
    var icon: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(.blue)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            Text(label)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
    }
}

struct LatestTransactions: View {
    let transactions = [
        Transaction(
            title: "Online txn fee",
            amount: -24.88,
            date: "Today",
            type: .debit,
        ),
        Transaction(
            title: "VAT online txn fee",
            amount: -4.11,
            date: "Yesterday",
            type: .debit,
        ),
        Transaction(
            title: "APPLE.COM BILL ITUNES.COM",
            amount: -1658.96,
            date: "Dec 20",
            type: .debit,
        ),
        Transaction(
            title: "DEC2025BUNDLEFEE",
            amount: -1700.00,
            date: "Dec 19",
            type: .debit,
        ),
        Transaction(
            title: "Tax Rebate",
            amount: 62000.00,
            date: "Dec 17",
            type: .credit,
        ),
    ]

    var body: some View {
        VStack {
            HStack {
                Text("Latest Transactions")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                Spacer()
                Text("See All")
                    .font(.system(size: 15))
                    .foregroundStyle(.blue)
                    .fontWeight(.medium)
            }

            ForEach(transactions) { transaction in
                TransactionItem(transaction: transaction)
            }
        }
    }
}

struct TransactionItem: View {
    var transaction: Transaction
    var body: some View {
        HStack {
            Image(
                systemName: transaction.type == .debit
                    ? "arrow.up.right" : "arrow.down.left"
            )
            .foregroundColor(.blue)
            .padding()
            .overlay(
                Circle().stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(.system(size: 15))
                    .fontWeight(.medium)
                Text(transaction.date)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }
            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text(
                    transaction.amount >= 0
                        ? "MWK \(String(format: "%.2f", transaction.amount))"
                        : "MWK \(String(format: "%.2f", transaction.amount))"
                )
                .fontWeight(.medium)
                .font(.system(size: 15))
                .foregroundStyle(
                    transaction.type == .credit ? .green : .red
                )
            }
        }.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
    }
}

struct HeaderButton: View {
    var icon: String
    var onPress: () -> Void

    var body: some View {
        Button(action: onPress) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .symbolRenderingMode(.multicolor)

        }
        .buttonStyle(.plain)
        .frame(width: 40, height: 40)
    }
}

#Preview {
    HomeView()
}
