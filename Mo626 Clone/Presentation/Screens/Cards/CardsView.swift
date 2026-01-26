//
//  CardsView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 24/12/2025.
//

internal import Combine
import CoreMotion
import SwiftUI

enum CardNavigation: Hashable {
    case customize
}

struct CardsView: View {
    @State private var path = NavigationPath()

    @State private var currentCard: Int = 0

    let cards = [
        CardData(
            balance: "25,000.35",
            cardNumber: "3234 8678 4234 7628",
            cardHolder: "Wiza Munthali",
            expiryDate: "08/29",
            color: .blue,
            cvv: "032"
        ),
        CardData(
            balance: "15,500.00",
            cardNumber: "5678 1234 5678 9012",
            cardHolder: "Wiza Munthali",
            expiryDate: "12/28",
            color: .black,
            cvv: "234"
        ),
        CardData(
            balance: "8,200.50",
            cardNumber: "9012 3456 7890 1234",
            cardHolder: "Wiza Munthali",
            expiryDate: "05/27",
            color: .black,
            cvv: "924"
        ),
    ]
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 24) {
                CardsList(cards: cards, currentCard: $currentCard)
                Actions(
                    navigateToCustomize: {
                        path.append(CardNavigation.customize)
                    }
                )
                Spacer()
            }.padding()
                .navigationDestination(for: CardNavigation.self) { page in
                    switch page {
                    case .customize:
                        CustomizeView(cardData: cards[currentCard]).toolbar(
                            .hidden,
                            for: .tabBar
                        )
                    }
                }
        }
    }
}

struct Actions: View {
    let navigateToCustomize: () -> Void

    var body: some View {
        VStack(spacing: 12) {

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "lock.rotation")

                    Text("Reset pin")
                    Spacer()
                }.frame(maxWidth: .infinity)

                Divider()
            }

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "lock.rectangle.fill")

                    Text("Lock/Unlock card")
                    Spacer()
                }.frame(maxWidth: .infinity)

                Divider()
            }

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "person.badge.shield.exclamationmark")

                    Text("Report fraud")
                    Spacer()
                }.frame(maxWidth: .infinity)

                Divider()
            }

            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")

                    Text("Spending statistics")
                    Spacer()
                }.frame(maxWidth: .infinity)

                Divider()
            }

            VStack {
                HStack(spacing: 12) {
                    Image(systemName: "dollarsign.bank.building")

                    Text("Request forex")
                    Spacer()
                }.frame(maxWidth: .infinity)
                Divider()
            }

            VStack {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                    Text("Customize card")
                    Spacer()
                }
            }.onTapGesture {
                navigateToCustomize()
            }
        }.padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
    }
}

struct CustomCard: View {
    let card: CardData
    @StateObject private var motionManager = MotionManager()
    @State private var flipped: Bool = false

    var body: some View {
        ZStack {
            CardFront(card: card, motionManager: motionManager)
                .rotation3DEffect(
                    .degrees(flipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                ).opacity(flipped ? 0 : 1)

            CardBack(card: card, motionManager: motionManager).rotation3DEffect(
                .degrees(flipped ? 0 : -180),
                axis: (x: 0, y: 1, z: 0)
            ).opacity(flipped ? 1 : 0)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                flipped.toggle()
            }
        }
        .onAppear {
            motionManager.startMonitoring()
        }
        .onDisappear {
            motionManager.stopMonitoring()
        }
    }
}

struct CardFront: View {
    let card: CardData
    let motionManager: MotionManager

    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    card.color,
                    card.color.opacity(0.8),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Card content
            VStack(alignment: .leading) {
                HStack {
                    Image("wiza_logo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                    Spacer()
                    Image("visa")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                }

                Spacer()

                Text(card.cardNumber)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.bottom, 12)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Card holder")
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.caption)
                        Text(card.cardHolder)
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("Expiry date")
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.caption)
                        Text(card.expiryDate)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding()

            // Metallic light reflection that follows tilt
            RadialGradient(
                gradient: Gradient(colors: [
                    .white.opacity(0.4),
                    .white.opacity(0.2),
                    .clear,
                ]),
                center: UnitPoint(
                    x: 0.5 + motionManager.offsetX / 300,
                    y: 0.5 + motionManager.offsetY / 300
                ),
                startRadius: 20,
                endRadius: 300
            )
            .blendMode(.overlay)

            // Glossy shine overlay
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .white.opacity(0.3), location: 0),
                    .init(color: .clear, location: 0.3),
                    .init(color: .clear, location: 0.7),
                    .init(color: .white.opacity(0.2), location: 1),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blendMode(.overlay)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(0.3),
            radius: 20,
            x: motionManager.offsetX / 20,
            y: motionManager.offsetY / 20
        )
        .rotation3DEffect(
            .degrees(2),
            axis: (
                x: -motionManager.offsetY / 30,
                y: motionManager.offsetX / 30,
                z: 0
            ),
            perspective: 0.5
        )
    }
}

struct CardBack: View {
    let card: CardData
    let motionManager: MotionManager

    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    card.color,
                    card.color.opacity(0.8),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Card content
            VStack(alignment: .leading) {

                Spacer()

                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(card.cvv)
                            .foregroundStyle(.black).italic().padding(.trailing)
                    }

                }.padding(.vertical, 8).background(.white).padding()

                HStack {
                    Spacer()
                }.frame(height: 50).overlay(Rectangle()).opacity(0.6)
            }.padding(.bottom)

            // Metallic light reflection that follows tilt
            RadialGradient(
                gradient: Gradient(colors: [
                    .white.opacity(0.4),
                    .white.opacity(0.2),
                    .clear,
                ]),
                center: UnitPoint(
                    x: 0.5 + motionManager.offsetX / 300,
                    y: 0.5 + motionManager.offsetY / 300
                ),
                startRadius: 20,
                endRadius: 300
            )
            .blendMode(.overlay)

            // Glossy shine overlay
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .white.opacity(0.3), location: 0),
                    .init(color: .clear, location: 0.3),
                    .init(color: .clear, location: 0.7),
                    .init(color: .white.opacity(0.2), location: 1),
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blendMode(.overlay)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: .black.opacity(0.3),
            radius: 20,
            x: motionManager.offsetX / 20,
            y: motionManager.offsetY / 20
        )
        .rotation3DEffect(
            .degrees(2),
            axis: (
                x: -motionManager.offsetY / 30,
                y: motionManager.offsetX / 30,
                z: 0
            ),
            perspective: 0.5
        )
    }
}

struct CardsList: View {
    let cards: [CardData]

    @State private var currentIndex: CardData.ID?
    @Binding var currentCard: Int

    var body: some View {
        GeometryReader { geometry in

            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(cards) { card in
                        CustomCard(card: card)
                            .frame(width: geometry.size.width - 40)
                            .frame(height: 220)
                            .id(card.id)
                            .scrollTransition { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                    .opacity(phase.isIdentity ? 1 : 0.8)
                            }
                    }
                }
                .padding(.horizontal, 20)
                .scrollTargetLayout()
            }.scrollPosition(id: $currentIndex)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .onChange(of: currentIndex) { _, newID in
                if let id = newID, let idx = cards.firstIndex(where: { $0.id == id }) {
                    currentCard = idx
                }
            }
        }
        .frame(height: 240)
    }
}

struct CardData: Identifiable {
    let id = UUID()
    let balance: String
    let cardNumber: String
    let cardHolder: String
    let expiryDate: String
    let color: Color
    let cvv: String
}

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()

    @Published var offsetX: CGFloat = 0
    @Published var offsetY: CGFloat = 0
    @Published var rotation: Double = 0

    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 0.02
        motionManager.startDeviceMotionUpdates(to: .main) {
            [weak self] motion, error in
            guard let motion = motion else { return }

            let pitch = motion.attitude.pitch
            let roll = motion.attitude.roll

            // Convert tilt to offset (range: -50 to 50)
            self?.offsetX = CGFloat(roll) * 50
            self?.offsetY = CGFloat(pitch) * 50
            self?.rotation = roll * 20
        }
    }

    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
    }
}

#Preview {
    CardsView()
}
