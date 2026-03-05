//
//  HomeView.swift
//  90AquaCore
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    @State private var showAddEntry = false
    @State private var animateProgress = false
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }
    
    private var motivationalText: String {
        let pct = viewModel.progressPercentage
        if pct >= 1.0 { return "You did it! Stay hydrated." }
        if pct >= 0.75 { return "Almost there!" }
        if pct >= 0.5 { return "Great progress!" }
        if pct >= 0.25 { return "Keep going!" }
        if viewModel.todayTotal > 0 { return "Every drop counts" }
        return "Time to hydrate"
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f
    }
    
    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                    progressSection
                    goalCard
                    recentSection
                    Spacer(minLength: 100)
                }
            }
            .background(
            LinearGradient(
                colors: [Color.aquaBackground, Color.aquaWater.opacity(0.04)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
            
            addButton
        }
        .sheet(isPresented: $showAddEntry) {
            AddEntryView(viewModel: viewModel)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animateProgress = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.aquaWater)
                    
                    Text("AquaCore")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.aquaWater, .aquaDeep],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.aquaWater.opacity(0.2), Color.aquaWater.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(Color.aquaWater.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color.aquaWater.opacity(0.2), radius: 8, x: 0, y: 4)
                    Image(systemName: "drop.fill")
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.aquaWater, .aquaDeep],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            Text(dateFormatter.string(from: Date()))
                .font(.subheadline)
                .foregroundColor(.aquaDeep.opacity(0.7))
                .padding(.horizontal, 24)
        }
        .padding(.bottom, 24)
        .background(
            LinearGradient(
                colors: [
                    Color.aquaBackground,
                    Color.aquaWater.opacity(0.08),
                    Color.aquaWater.opacity(0.03)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private var progressSection: some View {
        VStack(spacing: 20) {
            InteractiveDropView(
                progress: viewModel.progressPercentage,
                animate: animateProgress
            )
            
            VStack(spacing: 8) {
                Text("\(viewModel.todayTotal) / \(viewModel.dailyGoal) ml")
                    .font(.headline)
                    .foregroundColor(.aquaDeep)
                    .contentTransition(.numericText())
                    .animation(.easeOut(duration: 0.3), value: viewModel.todayTotal)
                
                Text(motivationalText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.aquaWater)
            }
        }
        .padding(.vertical, 32)
    }
    
    private var goalCard: some View {
        HStack(spacing: 20) {
            Image(systemName: "drop.fill")
                .font(.system(size: 28))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.aquaWater, .aquaDeep],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily goal")
                    .font(.subheadline)
                    .foregroundColor(.aquaDeep.opacity(0.8))
                Text("\(viewModel.dailyGoal) ml")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
            }
            
            Spacer()
            
            Text("\(Int(viewModel.progressPercentage * 100))%")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.aquaWater)
        }
        .aquaCard()
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's intake")
                    .font(.headline)
                    .foregroundColor(.aquaDeep)
                
                Spacer()
                
                if !viewModel.todayEntries.isEmpty {
                    Text("\(viewModel.todayEntries.count) entries")
                        .font(.caption)
                        .foregroundColor(.aquaWater)
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.todayEntries.prefix(6)) { entry in
                        HStack(spacing: 10) {
                            Image(systemName: "drop.fill")
                                .font(.caption)
                                .foregroundColor(.aquaWater)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(entry.amountML) ml")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.aquaDeep)
                                Text(timeFormatter.string(from: entry.date))
                                    .font(.caption2)
                                    .foregroundColor(.aquaWater)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .aquaPill()
                    }
                    
                    if viewModel.todayEntries.isEmpty {
                        HStack(spacing: 8) {
                            Image(systemName: "drop")
                                .font(.title3)
                                .foregroundColor(.aquaWater.opacity(0.5))
                            Text("Tap + to add water")
                                .font(.subheadline)
                                .foregroundColor(.aquaWater.opacity(0.8))
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var addButton: some View {
        Button {
            showAddEntry = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Add water")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 18)
            .aquaButton()
        }
        .buttonStyle(.plain)
        .padding(.bottom, 32)
    }
}

#Preview {
    HomeView(viewModel: AquaCoreViewModel())
}
