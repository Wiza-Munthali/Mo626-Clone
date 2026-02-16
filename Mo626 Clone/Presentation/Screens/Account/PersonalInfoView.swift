//
//  PersonalInfoView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 26/01/2026.
//

import SwiftUI

struct PersonalInfoView: View {
    @State private var name: String = "Wiza Munthali"
    @State private var dob: String = "27/05/1999"
    @State private var email: String = "wizamunthali@gmail.com"
    @State private var phone: String = "+265 881 226 938"
    var body: some View {
        VStack{
            CustomField(title: "Name", icon: "person.fill", disabled: true, value: $name)

            CustomField(title: "Date of Birth", icon: "calendar", disabled: true, value: $dob)

            CustomField(title: "Email", icon: "mail.fill", disabled: false, value: $email)

            CustomField(title: "Phone", icon: "phone.fill", disabled: false, value: $phone)

            Spacer()
        }
    }
}

struct CustomField: View {
    var title: String
    var placeholder: String?
    var icon: String?
    var disabled: Bool
    @Binding var value: String
    var body: some View {
        VStack(spacing: 12){
            HStack{
                Text(title).font(.headline).bold()
                Spacer()
            }

            HStack {
                TextField(placeholder ?? "", text: $value)
                    .disabled(disabled)
                if let icon {
                    Image(systemName: icon)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        disabled ? Color.gray.opacity(0.3) : Color.black,
                        lineWidth: 1
                    )
            )
            .foregroundStyle(disabled ? Color.gray : Color.primary)
            

        }.padding()
    }
}

#Preview{
    PersonalInfoView()
}
