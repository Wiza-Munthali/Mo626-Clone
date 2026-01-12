//
//  ConfirmView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 07/01/2026.
//

import LocalAuthentication
import SwiftUI

struct ConfirmView: View {
    let onConfirm: () -> Void

    @State private var isAuthenticating = false

    var body: some View {
        VStack {

            Spacer()

            Text("Confirm Transaction").font(.title).bold()
            Text(
                "Please scan your Face ID to confirm the following transaction"
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding()

            Text(20000, format: .currency(code: "MWK"))
                .font(.title)
                .bold().padding(.bottom)

            HStack {
                VStack(alignment: .center) {
                    Text("Wiza Munthali").fontWeight(.medium).font(
                        .headline
                    )
                    Text("123456789").foregroundStyle(
                        .secondary
                    )
                }

                Spacer()
                Image(systemName: "arrow.right")
                    .font(.title)
                    .foregroundStyle(.blue)
                    .symbolEffect(
                        .wiggle.byLayer,
                        options: .repeat(.periodic(delay: 1.0))
                    )
                //                    .symbolEffect(
                //                        .drawOn.individually,
                //                        options: .repeat(.periodic(delay: 1.0))
                //                    )
                Spacer()

                VStack(alignment: .center) {
                    Text("Thierry Henry").fontWeight(.medium).font(
                        .headline
                    )
                    Text("121212").foregroundStyle(
                        .secondary
                    )
                }

            }

            Spacer()

            Button(action: {
                guard !isAuthenticating else { return }
                isAuthenticating = true
                authenticate { success in
                    isAuthenticating = false
                    guard success else { return }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        onConfirm()
                    }
                }
            }) {
                Spacer()
                Text("Confirm").bold().padding(.vertical, 8)
                Spacer()
            }.buttonStyle(.borderedProminent)
                .disabled(isAuthenticating)

        }.padding()
    }

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var authError: NSError?

        guard
            context.canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: &authError
            )
        else {
            DispatchQueue.main.async { completion(false) }
            return
        }

        let reason = "Confirm this transaction using Face ID"

        context.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: reason
        ) { success, error in
            DispatchQueue.main.async {
                if let error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                completion(success)
            }
        }
    }

}

#Preview {
    ConfirmView(onConfirm: {})
}
