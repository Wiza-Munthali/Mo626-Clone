//
//  CustomizeView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 19/01/2026.
//

import PhotosUI
import SwiftUI

struct CustomizeView: View {
    let cardData: CardData

    @State private var color: Color
    @State private var selection: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isLoading = false

    init(
        cardData: CardData
    ) {
        self.cardData = cardData
        _color = State(initialValue: cardData.color)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            ZStack {
                CustomizableCard(
                    card: cardData,
                    image: selectedImage,
                    color: color
                )
                .frame(height: 220)
                .frame(maxWidth: .infinity)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }

            HStack(spacing: 12) {
                PhotosPicker(selection: $selection, matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                .blue,
                                lineWidth: 2
                            )
                            .frame(width: 50, height: 50)
                        Image(systemName: "photo").padding()
                    }

                }
                .onChange(of: selection) { oldValue, newValue in
                    guard let newValue else { return }
                    changeImage(to: newValue)
                }

                Button(action: {
                    color = .blue
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            .blue
                        )
                        .frame(width: 50, height: 50)
                }.buttonStyle(
                    .plain
                )

                Button(action: {
                    color = .red
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            .red
                        )
                        .frame(width: 50, height: 50)
                }.buttonStyle(
                    .plain
                )

                Button(action: {
                    color = .yellow
                }) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            .yellow
                        )
                        .frame(width: 50, height: 50)
                }.buttonStyle(
                    .plain
                )

                ColorPicker(
                    selection: $color,
                    supportsOpacity: true,
                    label: {
                        Text("Pick A Color!")
                    }
                ).labelsHidden()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                .background
                            )
                            .frame(width: 50, height: 50)
                    ).padding(.leading, 12)

                Spacer()
            }

            Spacer()

            Button(action: {

            }) {
                Spacer()
                Text("Request Customization")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.vertical, 8)
                Spacer()
            }.buttonStyle(.borderedProminent)
        }.padding()

            .navigationTitle("Customize Card")
            .navigationBarTitleDisplayMode(.inline)

    }

    func changeImage(to pickerItem: PhotosPickerItem) {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                if let data = try await pickerItem.loadTransferable(
                    type: Data.self
                ) {
                    if let uiImage = UIImage(data: data) {
                        withAnimation {
                            self.selectedImage = uiImage
                        }
                    }
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}

struct CustomizableCard: View {
    let card: CardData
    let image: UIImage?

    let color: Color

    private var fg: Color {
        image == nil ? color.readableTextColor() : .white
    }

    var body: some View {
        ZStack {
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.25),
                                    Color.black.opacity(0.45),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        ).frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                } else {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color,
                            color.opacity(0.8),
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))

            // Card content
            VStack(alignment: .leading) {
                HStack {
                    Image("wiza_logo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(fg)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                    Spacer()
                    Image("visa")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(fg)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                }

                Spacer()

                Text(card.cardNumber)
                    .font(.title2)
                    .foregroundStyle(fg)
                    .bold()
                    .padding(.bottom, 12)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Card holder")
                            .foregroundStyle(fg.opacity(0.7))
                            .font(.caption)
                        Text(card.cardHolder)
                            .foregroundStyle(fg)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("Expiry date")
                            .foregroundStyle(fg.opacity(0.7))
                            .font(.caption)
                        Text(card.expiryDate)
                            .foregroundStyle(fg)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 220, maxHeight: 220)

        }
        .frame(maxWidth: .infinity, minHeight: 220, maxHeight: 220)
        .clipShape(RoundedRectangle(cornerRadius: 18))

    }
}

extension Color {
    func readableTextColor(threshold: CGFloat = 0.6) -> Color {
        // Convert to UIColor (works well for most non-dynamic colors)
        let ui = UIColor(self)

        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)

        // Relative luminance (WCAG-ish)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b

        return luminance > threshold ? .black : .white
    }
}

#Preview {
    let data = CardData(
        balance: "25,000.35",
        cardNumber: "3234 8678 4234 7628",
        cardHolder: "Wiza Munthali",
        expiryDate: "08/29",
        color: .blue,
        cvv: "032"
    )
    CustomizeView(cardData: data)
}
