//
//  StatisticsView.swift
//  90AquaCore
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    @State private var showExportSheet = false
    @State private var exportURL: URL?
    
    private var weekLabels: [String] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: -6 + offset, to: Date()).map { formatter.string(from: $0) }
        }
    }
    
    private var intensityDistribution: [(WorkoutIntensity, Int)] {
        let grouped = Dictionary(grouping: viewModel.entries) { $0.workoutIntensity ?? .rest }
        return WorkoutIntensity.allCases.map { intensity in
            let count = grouped[intensity]?.count ?? 0
            return (intensity, count)
        }.filter { $0.1 > 0 }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                HStack(spacing: 12) {
                    StatCard(title: "Avg/Day", value: "\(viewModel.averageDailyVolume) ml")
                    StatCard(title: "Best Streak", value: "\(viewModel.bestStreak) days")
                    StatCard(title: "Monthly", value: "\(viewModel.monthlyTotal) ml")
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Weekly Overview")
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    
                    Chart {
                        ForEach(Array(weekLabels.enumerated()), id: \.offset) { index, day in
                            BarMark(
                                x: .value("Day", day),
                                y: .value("ml", index < viewModel.weeklyAverages.count ? viewModel.weeklyAverages[index] : 0)
                            )
                            .foregroundStyle(Color.aquaWater)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: .automatic) { _ in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                                .foregroundStyle(Color.aquaWater.opacity(0.2))
                            AxisValueLabel()
                                .foregroundStyle(Color.aquaDeep)
                        }
                    }
                    .chartXAxis {
                        AxisMarks { _ in
                            AxisValueLabel()
                                .foregroundStyle(Color.aquaDeep)
                        }
                    }
                    .frame(height: 200)
                }
                .aquaCard(cornerRadius: 20)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Week Comparison")
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("This Week")
                                .font(.caption)
                                .foregroundColor(.aquaDeep)
                            Text("\(viewModel.currentWeekTotal) ml")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.aquaWater)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .aquaSmallCard()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Last Week")
                                .font(.caption)
                                .foregroundColor(.aquaDeep)
                            Text("\(viewModel.previousWeekTotal) ml")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.aquaWater)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .aquaSmallCard()
                    }
                    
                    let diff = viewModel.currentWeekTotal - viewModel.previousWeekTotal
                    if viewModel.previousWeekTotal > 0 {
                        HStack {
                            Image(systemName: diff >= 0 ? "arrow.up.right" : "arrow.down.right")
                                .foregroundColor(diff >= 0 ? Color.aquaWater : Color.aquaDeep.opacity(0.7))
                            Text("\(diff >= 0 ? "+" : "")\(diff) ml vs last week")
                                .font(.caption)
                                .foregroundColor(.aquaDeep)
                        }
                    }
                }
                .aquaCard(cornerRadius: 20)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Export")
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    
                    HStack(spacing: 12) {
                        Button {
                            exportURL = ExportService.exportEntries(viewModel.entries, format: .csv)
                            showExportSheet = true
                        } label: {
                            Label("Export CSV", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.aquaWater, .aquaDeep],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color.aquaWater.opacity(0.4), radius: 8, x: 0, y: 4)
                                        .shadow(color: Color.aquaDeep.opacity(0.2), radius: 2, x: 0, y: 1)
                                )
                        }
                        
                        Button {
                            exportURL = ExportService.exportEntries(viewModel.entries, format: .pdf)
                            showExportSheet = true
                        } label: {
                            Label("Export PDF", systemImage: "doc.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.aquaWater, .aquaDeep],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: Color.aquaWater.opacity(0.4), radius: 8, x: 0, y: 4)
                                        .shadow(color: Color.aquaDeep.opacity(0.2), radius: 2, x: 0, y: 1)
                                )
                        }
                    }
                }
                .aquaCard(cornerRadius: 20)
                .padding(.horizontal)
                
                if !intensityDistribution.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Intensity Distribution")
                            .font(.headline)
                            .foregroundColor(.aquaDeep)
                        
                        Chart(intensityDistribution, id: \.0) { item in
                            SectorMark(
                                angle: .value("Count", item.1),
                                innerRadius: .ratio(0.5),
                                angularInset: 2
                            )
                            .foregroundStyle(by: .value("Intensity", item.0.displayName))
                            .cornerRadius(4)
                        }
                        .chartForegroundStyleScale([
                            "Rest": Color.aquaWater.opacity(0.4),
                            "Light": Color.aquaWater.opacity(0.6),
                            "Moderate": Color.aquaWater.opacity(0.8),
                            "Intense": Color.aquaWater,
                            "Extreme": Color.aquaDeep
                        ])
                        .chartLegend(position: .bottom, alignment: .center)
                        .frame(height: 220)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(intensityDistribution, id: \.0) { intensity, count in
                                HStack {
                                    Circle()
                                        .fill(colorForIntensity(intensity))
                                        .frame(width: 12, height: 12)
                                    Text(intensity.displayName)
                                        .foregroundColor(.aquaDeep)
                                    Spacer()
                                    Text("\(count)")
                                        .foregroundColor(.aquaWater)
                                }
                            }
                        }
                    }
                .aquaCard(cornerRadius: 20)
                .padding(.horizontal)
                }
            }
            .padding(.vertical, 24)
        }
        .background(
            LinearGradient(
                colors: [Color.aquaBackground, Color.aquaWater.opacity(0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .sheet(isPresented: $showExportSheet) {
            if let url = exportURL {
                ShareSheet(items: [url])
                    .onDisappear { exportURL = nil }
            }
        }
    }
    
    private func colorForIntensity(_ intensity: WorkoutIntensity) -> Color {
        switch intensity {
        case .rest: return Color.aquaWater.opacity(0.4)
        case .light: return Color.aquaWater.opacity(0.6)
        case .moderate: return Color.aquaWater.opacity(0.8)
        case .intense: return Color.aquaWater
        case .extreme: return Color.aquaDeep
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.aquaDeep)
            Text(value)
                .font(.headline)
                .foregroundColor(.aquaWater)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aquaSmallCard()
    }
}

#Preview {
    StatisticsView(viewModel: AquaCoreViewModel())
}
