//
//  CircularProgressView.swift
//  90AquaCore
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat = 20
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.aquaWater.opacity(0.2), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.aquaWater,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.72)
        .frame(width: 200, height: 200)
}
