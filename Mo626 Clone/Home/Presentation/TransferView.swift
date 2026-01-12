//
//  TransferView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 05/01/2026.
//

import SwiftUI

struct TransferView: View {
    let onSend: () -> Void

    @State private var enteredAmount: String = "0"
    let balance: Double = 200000.00

    var body: some View {
        VStack(spacing: 12) {
            RecipientSelector()
            Spacer()
            Amount(enteredAmount: enteredAmount, balance: balance)
            Spacer()
            Balance(enteredAmount: enteredAmount, balance: balance)
            KeyPad(enteredAmount: $enteredAmount)
            Button(action: onSend) {
                Spacer()
                Text("Send").bold().font(.title2).padding(.vertical, 8)
                Spacer()
            }.buttonStyle(.borderedProminent)
        }.padding()
            .navigationTitle("Transfer")
    }
}

struct RecipientSelector: View {
    @State private var showOtherActions = false
    @State private var selectedRecipient: Recipient?

    var body: some View {
        VStack {
            if let recipient = selectedRecipient {
                Button {
                    showOtherActions = true
                } label: {
                    RecipientCard(recipient: recipient)
                }
                .buttonStyle(.plain)
            } else {
                HStack {
                    Button(action: {
                        showOtherActions = true
                    }) {
                        HStack {
                            Image(
                                systemName: "person.crop.circle.fill.badge.plus"
                            )
                            .imageScale(.large)

                            Text("Select Recipient")
                            Spacer()

                            Image(systemName: "chevron.right")
                        }.contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }.padding().overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
            }
        }.sheet(isPresented: $showOtherActions) {
            RecipientSelectorModal { recipient in
                selectedRecipient = recipient
                showOtherActions = false  // optional; dismiss() in modal also works
            }
            .presentationDetents([.large])
        }
    }
}

struct RecipientSelectorModal: View {
    @Environment(\.dismiss) var dismiss
    let onSelect: (Recipient) -> Void

    @State var name: String = ""
    @State var showQRScanner = false
    @State private var selectedTab = 0
    let tabs = ["Recent", "All", "Favorite"]
    @State var scanned: String = ""

    var body: some View {
        NavigationStack {

            Group {
                if showQRScanner {
                    VStack(spacing: 20) {
                        Spacer()
                        ScannerView(scanned: $scanned).frame(
                            width: 300,
                            height: 300
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 3)
                        )

                        Spacer()
                        Text(
                            "Scan the recipient’s QR code to autofill transfer details."
                        ).font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center).padding()

                        Image(systemName: "qrcode.viewfinder")
                            .font(.largeTitle)
                        //                            .symbolEffect(
                        //                                .drawOn.individually,
                        //                                options: .repeat(.continuous),
                        //                                isActive: true
                        //                            )

                        Button(action: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showQRScanner.toggle()
                            }
                        }) {
                            Text("Cancel").bold().foregroundStyle(.secondary)
                        }.buttonStyle(.plain)
                    }.padding()
                        .transition(.move(edge: .bottom))
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Who do you want to send money to?")
                            .font(.callout)
                            .foregroundStyle(.gray)
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))

                            TextField(
                                "Name, Number or Account number",
                                text: $name
                            )
                            .textFieldStyle(.plain)

                            Button(action: {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showQRScanner.toggle()
                                }
                            }) {
                                Image(systemName: "qrcode.viewfinder").font(
                                    .system(size: 18)
                                )
                            }.buttonStyle(.plain)
                        }.padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(
                                        Color.gray.opacity(0.1),
                                        lineWidth: 1
                                    )
                            )

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(tabs.enumerated()), id: \.offset)
                                {
                                    index,
                                    tab in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedTab = index
                                        }
                                    }) {
                                        Text(tab)
                                            .font(.system(size: 15))
                                            .fontWeight(
                                                selectedTab == index
                                                    ? .semibold : .regular
                                            )
                                            .foregroundColor(
                                                selectedTab == index
                                                    ? .primary : .gray
                                            )
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                selectedTab == index
                                                    ? Color(.systemGray5)
                                                    : Color.clear
                                            )
                                            .cornerRadius(20)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Group {
                            switch selectedTab {
                            case 0:
                                RecentRecipients(onSelect: select)
                            case 1:
                                AllRecipients(onSelect: select)
                            case 2:
                                FavoriteRecipients(onSelect: select)
                            default:
                                RecentRecipients(onSelect: select)
                            }
                        }
                        .transition(.opacity)

                    }.padding(.horizontal, 20)
                        .padding(.top, 34)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .top))
                }
            }

        }.navigationTitle("Select Recipient")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }.onChange(of: scanned) { _, newValue in
                let trimmed = newValue.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                guard !trimmed.isEmpty else { return }

                showQRScanner = false
                let recipient = Recipient(
                    id: UUID(),
                    name: "Wiza Munthali",
                    accountNumber: "123456789",
                    bankName: "Bank of Illustration",
                    phoneNumber: "+265 123 456 78 90",
                    photo: "wiza",
                    favorite: true
                )
                select(recipient)
            }
    }

    private func select(_ recipient: Recipient) {
        onSelect(recipient)
        dismiss()
    }
}

struct RecipientCard: View {
    var recipient: Recipient

    var body: some View {
        HStack(spacing: 12) {
            if let photo = recipient.photo {
                Image(photo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Text(recipient.name.prefix(1))
                    .font(.headline)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(.blue))
                    .foregroundStyle(.white)
            }
            VStack(alignment: .leading) {
                Text(recipient.name).font(.title3)
                HStack {
                    Text(recipient.bankName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("•").font(.caption).foregroundStyle(.secondary)
                    Text(recipient.accountNumber).font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()

            if recipient.favorite {
                Image(systemName: "star.hexagon.fill").foregroundStyle(.yellow)
            }
        }
    }
}

struct RecentRecipients: View {
    let onSelect: (Recipient) -> Void
    let recentRecipeints = [
        Recipient(
            id: UUID(),
            name: "Wiza Munthali",
            accountNumber: "123456789",
            bankName: "Bank of Illustration",
            phoneNumber: "+265 123 456 78 90",
            photo: "wiza",
            favorite: true
        ),
        Recipient(
            id: UUID(),
            name: "Micheal Jackson",
            accountNumber: "987654321",
            bankName: "Stonehenge Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Thierry Henry",
            accountNumber: "121212",
            bankName: "French Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil,
            favorite: true
        ),
        Recipient(
            id: UUID(),
            name: "Mesut Ozil",
            accountNumber: "1928038",
            bankName: "German Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil
        ),
    ]
    var body: some View {
        ScrollView {
            ForEach(recentRecipeints) { recent in
                RecipientCard(recipient: recent).contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(recent)
                    }
            }
        }
    }
}

struct AllRecipients: View {
    let onSelect: (Recipient) -> Void
    let all = [
        Recipient(
            id: UUID(),
            name: "Wiza Munthali",
            accountNumber: "123456789",
            bankName: "Bank of Illustration",
            phoneNumber: "+265 123 456 78 90",
            photo: "wiza",
            favorite: true
        ),
        Recipient(
            id: UUID(),
            name: "Micheal Jackson",
            accountNumber: "987654321",
            bankName: "Stonehenge Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Thierry Henry",
            accountNumber: "121212",
            bankName: "French Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil,
            favorite: true
        ),
        Recipient(
            id: UUID(),
            name: "Mesut Ozil",
            accountNumber: "1928038",
            bankName: "German Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Daniel Phiri",
            accountNumber: "84019273",
            bankName: "Unity Bank",
            phoneNumber: "+265 991 203 445",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Sarah Banda",
            accountNumber: "57291038",
            bankName: "National Trust Bank",
            phoneNumber: "+265 884 552 901",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Jacob Mbewe",
            accountNumber: "30928471",
            bankName: "First Capital Bank",
            phoneNumber: "+265 999 781 224",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Emily Carter",
            accountNumber: "66190284",
            bankName: "Summit Bank",
            phoneNumber: "+265 888 310 776",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Patrick Nkhoma",
            accountNumber: "19283746",
            bankName: "Standard Finance",
            phoneNumber: "+265 981 664 092",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Aisha Mohammed",
            accountNumber: "45091827",
            bankName: "Crescent Bank",
            phoneNumber: "+265 876 442 118",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Brian Thompson",
            accountNumber: "72819364",
            bankName: "NorthStar Bank",
            phoneNumber: "+265 910 338 447",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Linda Mwale",
            accountNumber: "38475619",
            bankName: "People’s Bank",
            phoneNumber: "+265 994 120 889",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Chris Walker",
            accountNumber: "91028475",
            bankName: "Pioneer Bank",
            phoneNumber: "+265 882 903 771",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Natasha Ivanova",
            accountNumber: "56473829",
            bankName: "Aurora Bank",
            phoneNumber: "+265 970 661 532",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Kelvin Zulu",
            accountNumber: "83920164",
            bankName: "Atlas Bank",
            phoneNumber: "+265 995 771 340",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Olivia Brown",
            accountNumber: "27481936",
            bankName: "Harbor Bank",
            phoneNumber: "+265 888 402 615",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Henry Chirwa",
            accountNumber: "61920384",
            bankName: "Metro Bank",
            phoneNumber: "+265 981 774 903",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Sophia Nguyen",
            accountNumber: "50291847",
            bankName: "Pacific Bank",
            phoneNumber: "+265 912 558 664",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "George Tembo",
            accountNumber: "91827364",
            bankName: "Civic Bank",
            phoneNumber: "+265 993 118 720",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Isabella Rossi",
            accountNumber: "74629183",
            bankName: "Continental Bank",
            phoneNumber: "+265 876 990 431",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Franklin Peters",
            accountNumber: "36581920",
            bankName: "Heritage Bank",
            phoneNumber: "+265 910 224 559",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Memory Gondwe",
            accountNumber: "82019374",
            bankName: "Gateway Bank",
            phoneNumber: "+265 884 670 118",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Victor Alvarez",
            accountNumber: "49182736",
            bankName: "Global Bank",
            phoneNumber: "+265 999 331 907",
            photo: nil
        ),
        Recipient(
            id: UUID(),
            name: "Ruth Kamanga",
            accountNumber: "63729184",
            bankName: "Prime Bank",
            phoneNumber: "+265 981 558 002",
            photo: nil
        ),

    ]
    var sorted: [Recipient] {
        all.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name)
                == .orderedAscending
        }
    }
    var body: some View {
        ScrollView {
            ForEach(sorted) { recipient in
                RecipientCard(recipient: recipient).contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(recipient)
                    }
            }
        }
    }
}

struct FavoriteRecipients: View {
    let onSelect: (Recipient) -> Void
    let favorites = [
        Recipient(
            id: UUID(),
            name: "Wiza Munthali",
            accountNumber: "123456789",
            bankName: "Bank of Illustration",
            phoneNumber: "+265 123 456 78 90",
            photo: "wiza",
            favorite: true
        ),
        Recipient(
            id: UUID(),
            name: "Thierry Henry",
            accountNumber: "121212",
            bankName: "French Bank",
            phoneNumber: "+265 123 456 78 90",
            photo: nil,
            favorite: true
        ),
    ]
    var body: some View {
        List {
            ForEach(favorites) { favorite in
                RecipientCard(recipient: favorite)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onSelect(favorite)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                                // Unfavorite action
                        } label: {
                            Label("Unfavorite", systemImage: "star.slash")
                        }
                    }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

struct Amount: View {
    let enteredAmount: String

    let balance: Double

    var amount: Double {
        Double(enteredAmount) ?? 0
    }

    var exceedBalance: Bool {
        amount > balance && amount > 0
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Enter Amount").font(.callout).foregroundStyle(.gray)

            HStack {
                if exceedBalance {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.red)
                }
                Text(amount, format: .currency(code: "MWK"))
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(exceedBalance ? .red : .primary)
            }.animation(.easeInOut(duration: 0.2), value: exceedBalance)
        }
    }
}

struct Balance: View {
    let enteredAmount: String
    let balance: Double

    var body: some View {
        HStack(spacing: 5) {
            Text("Available balance:").font(.callout).foregroundStyle(.gray)

            Text(balance, format: .currency(code: "MWK")).font(.callout)
                .fontWeight(.medium)
        }
    }
}

struct KeyPad: View {
    @Binding var enteredAmount: String

    func appendDigit(_ digit: String) {
        if enteredAmount == "0" {
            enteredAmount = digit
        } else {
            enteredAmount += digit
        }
    }

    func appendDecimal() {
        if !enteredAmount.contains(".") {
            enteredAmount += "."
        }
    }

    func deleteLastDigit() {
        if !enteredAmount.isEmpty {
            enteredAmount.removeLast()
            if enteredAmount.isEmpty {
                enteredAmount = "0"
            }
        }
    }

    var body: some View {
        VStack(spacing: 36) {
            HStack(spacing: 12) {
                KeyPadItem(
                    label: "1"

                ) {
                    appendDigit("1")
                }
                Spacer()
                KeyPadItem(
                    label: "2"
                ) {
                    appendDigit("2")
                }
                Spacer()
                KeyPadItem(
                    label: "3"
                ) {
                    appendDigit("3")
                }
            }

            HStack(spacing: 12) {
                KeyPadItem(
                    label: "4"
                ) {
                    appendDigit("4")
                }
                Spacer()
                KeyPadItem(
                    label: "5"
                ) {
                    appendDigit("5")
                }
                Spacer()
                KeyPadItem(
                    label: "6"
                ) {
                    appendDigit("6")
                }
            }

            HStack(spacing: 12) {
                KeyPadItem(
                    label: "7"
                ) {
                    appendDigit("7")
                }
                Spacer()
                KeyPadItem(
                    label: "8"
                ) {
                    appendDigit("8")
                }
                Spacer()
                KeyPadItem(
                    label: "9"
                ) {
                    appendDigit("9")
                }
            }

            HStack(spacing: 12) {
                KeyPadItem(
                    label: "."
                ) {
                    appendDecimal()
                }

                Spacer()

                KeyPadItem(
                    label: "0"
                ) {
                    appendDigit("0")
                }
                Spacer()
                KeyPadItem(
                    label: "",
                    isIcon: true,
                    iconName: "delete.left.fill"
                ) {
                    deleteLastDigit()
                }
            }
        }.padding()
    }
}

struct KeyPadItem: View {
    var label: String
    var isIcon: Bool = false
    var iconName: String = "'"
    var onPress: () -> Void

    let impact = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        Button(action: {
            impact.impactOccurred()
            onPress()
        }) {
            if isIcon {
                Image(systemName: iconName)
            } else {
                Text(label)
                    .font(.title)
                    .fontWeight(.medium)
            }
        }.buttonStyle(.plain)
            .frame(width: 50, height: 50)
    }
}

#Preview {
    TransferView(onSend: {})
}
