//
//  RecieptView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 07/01/2026.
//

import DotLottie
import SwiftUI

struct ReceiptView: View {
    let onBackToHome: () -> Void

    @State private var startAnimation = false

    var body: some View {
        VStack(spacing: 12) {
            if startAnimation {
                DotLottieAnimation(
                    fileName: "success",
                    config: AnimationConfig(
                        autoplay: true,
                        loop: false,
                        speed: 1,
                    ),
                )
                .view()
                .frame(width: 150, height: 150)

            } else {
                VStack {

                }.frame(height: 150)
            }

            Text("Transaction Success!").font(.title).bold().padding(
                .bottom,
                24
            )

            HStack {
                Text("Details").font(.headline)
                Spacer()
            }.padding(.bottom, 8)

            VStack(spacing: 12) {
                DetailItem(
                    leading: "Transaction ID",
                    trailing: "2026-FTNQMAJ-0701"
                )
                DetailItem(leading: "Recipient", trailing: "Wiza Munthali")
                DetailItem(leading: "Account Number", trailing: "123456789")
                DetailItem(
                    leading: "Date",
                    trailing: "19:00 7th January 2026"
                )
                DetailItem(
                    leading: "Time",
                    trailing: "07:34:12 PM (UTC)"
                )
                DetailItem(leading: "Note", trailing: "Loan Repayment")

            }
            Divider()
            HStack {
                Text("Summary").font(.headline)
                Spacer()
            }.padding(.bottom, 8)
            VStack(spacing: 12) {
                DetailItem(leading: "Amount", trailing: "MWK 500,000.00")
                DetailItem(
                    leading: "Transaction Fee",
                    trailing: "MWK 500.00"
                )
            }
            Divider()
            HStack {
                Text("Total").font(.headline)
                Spacer()
                Text("MWK 500,500.00").fontWeight(.semibold)
            }
            Spacer()
            Button(
                action:
                    onBackToHome
            ) {
                Spacer()
                Text("Back to Home").bold().padding(.vertical, 8)
                Spacer()
            }.buttonStyle(.borderedProminent)
        }.padding().toolbar {
            Button(action: {
                // Share Receipt
            }) {
                Image(systemName: "square.and.arrow.up")
            }.buttonStyle(.borderless)
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startAnimation = true
                //                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        }

    }
}

struct DetailItem: View {
    let leading: String
    let trailing: String
    var body: some View {
        HStack {
            Text(leading).foregroundStyle(.secondary).font(.subheadline)
            Spacer()
            Text(trailing).font(.subheadline)
        }
    }
}

#Preview {
    ReceiptView(onBackToHome: {})
}
