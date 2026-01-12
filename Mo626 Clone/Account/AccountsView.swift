//
//  AccountsView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 24/12/2025.
//
import SwiftUI

struct AccountsView: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var biometricsTurnedOn = false

    var body: some View {
        VStack (spacing: 24){
            VStack{
                ZStack(alignment: .bottomTrailing) {
                    Image("wiza")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                    Image(systemName: "pencil").foregroundStyle(.white)
                        .frame(width: 40, height: 40).background(.blue)
                        .clipShape(Circle())
                }
                Text("Wiza Munthali")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                Text("wizamunthali@gmail.com")
                    .font(.system(size: 14)).foregroundStyle(.gray)
            }
            VStack(alignment: .leading){
                Text("Account")
                    .font(.system(size: 15))
                    .fontWeight(.medium)

                HStack{
                    Image(systemName: "person").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.1))
                        .clipShape(Circle())

                    Text("Personal Information")

                    Spacer()

                    Image(systemName: "chevron.right").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                }
            }

            VStack(alignment: .leading){
                Text("Security")
                    .font(.system(size: 15))
                    .fontWeight(.medium)

                HStack{
                    Image(systemName: "lock").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.1))
                        .clipShape(Circle())

                    Text("Change Pin")

                    Spacer()

                    Image(systemName: "chevron.right").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                }

                HStack{
                    Image(systemName: "faceid").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.1))
                        .clipShape(Circle())

                    Text("Enable Biometrics")

                    Spacer()

                    Toggle("Biometrics", isOn: $biometricsTurnedOn)
                        .labelsHidden()
                }

                HStack{
                    Image(systemName: "lock.rectangle.on.rectangle").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.1))
                        .clipShape(Circle())

                    Text("Enable Multi-Factor Authentication")

                    Spacer()

                    Image(systemName: "chevron.right").foregroundStyle(colorScheme == .dark ? .white : .black)
                        .frame(width: 50, height: 50)
                }
            }
            Spacer()
        }.padding()
    }
}

#Preview {
    AccountsView()
}
