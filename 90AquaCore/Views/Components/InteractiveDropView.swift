//
//  InteractiveDropView.swift
//  90AquaCore
//

import SwiftUI

struct DropShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var path = Path()
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addCurve(
            to: CGPoint(x: w, y: h * 0.6),
            control1: CGPoint(x: w * 0.95, y: h * 0.15),
            control2: CGPoint(x: w, y: h * 0.4)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control1: CGPoint(x: w * 0.9, y: h * 0.85),
            control2: CGPoint(x: w * 0.7, y: h)
        )
        path.addCurve(
            to: CGPoint(x: 0, y: h * 0.6),
            control1: CGPoint(x: w * 0.3, y: h),
            control2: CGPoint(x: w * 0.1, y: h * 0.85)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.5, y: 0),
            control1: CGPoint(x: 0, y: h * 0.4),
            control2: CGPoint(x: w * 0.05, y: h * 0.15)
        )
        path.closeSubpath()
        return path
    }
}

struct InteractiveDropView: View {
    let progress: Double
    let animate: Bool
    @State private var pulseScale: CGFloat = 1.0

    private var fillProgress: CGFloat {
        min(1, max(0, CGFloat(animate ? progress : 0)))
    }

    var body: some View {
        let dropWidth: CGFloat = 180
        let dropHeight: CGFloat = 220
        let fillHeight = dropHeight * fillProgress

        ZStack {
            DropShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.aquaWater.opacity(0.08),
                            Color.aquaWater.opacity(0.18)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: dropWidth, height: dropHeight)
                .shadow(color: Color.aquaDeep.opacity(0.08), radius: 16, x: 0, y: 8)

            DropShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.aquaWater.opacity(0.6),
                            Color.aquaWater,
                            Color.aquaDeep
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: dropWidth, height: dropHeight)
                .mask(alignment: .bottom) {
                    Rectangle()
                        .frame(height: fillHeight)
                }

            if fillProgress > 0.15 {
                DropShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.5),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .center
                        ),
                        lineWidth: 1.5
                    )
                    .frame(width: dropWidth, height: dropHeight)
            }

            VStack(spacing: 6) {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundColor(fillProgress > 0.45 ? .white : .aquaDeep)
                    .shadow(color: .black.opacity(fillProgress > 0.45 ? 0.15 : 0), radius: 1)
                    .contentTransition(.numericText())
                    .animation(.easeOut(duration: 0.3), value: progress)

                Text("goal")
                    .font(.caption)
                    .foregroundColor(fillProgress > 0.45 ? .white.opacity(0.9) : .aquaDeep.opacity(0.75))
            }
            .scaleEffect(pulseScale)
        }
        .animation(.spring(response: 0.65, dampingFraction: 0.75), value: fillProgress)
        .onChange(of: progress) { _, _ in
            withAnimation(.easeInOut(duration: 0.12)) {
                pulseScale = 1.04
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeOut(duration: 0.18)) {
                    pulseScale = 1.0
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        InteractiveDropView(progress: 0.0, animate: true)
        InteractiveDropView(progress: 0.5, animate: true)
        InteractiveDropView(progress: 1.0, animate: true)
    }
    .padding()
}
