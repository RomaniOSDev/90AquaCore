//
//  DashboardView.swift
//  90AquaCore
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    @State private var showAddEntry = false
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .long
        return f
    }
    
    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.timeStyle = .short
        return f
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("AquaCore")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.aquaDeep)
                    
                    Text(dateFormatter.string(from: Date()))
                        .font(.subheadline)
                        .foregroundColor(.aquaWater)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                ZStack {
                    CircularProgressView(progress: viewModel.progressPercentage)
                        .frame(width: 220, height: 220)
                    
                    VStack(spacing: 4) {
                        Text("\(viewModel.todayTotal) / \(viewModel.dailyGoal) ml")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.aquaDeep)
                            .animation(.easeInOut(duration: 0.5), value: viewModel.todayTotal)
                    }
                }
                .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.aquaWater)
                        Text("Daily Goal")
                            .font(.headline)
                            .foregroundColor(.aquaDeep)
                    }
                    
                    Text("\(viewModel.dailyGoal) ml")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.aquaWater)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.aquaDeep.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Entries")
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.todayEntries.prefix(5)) { entry in
                                HStack(spacing: 8) {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.aquaWater)
                                        .font(.caption)
                                    Text("\(entry.amountML) ml")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.aquaDeep)
                                    Text(timeFormatter.string(from: entry.date))
                                        .font(.caption)
                                        .foregroundColor(.aquaWater)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.aquaDeep.opacity(0.08), radius: 4, x: 0, y: 2)
                            }
                            
                            if viewModel.todayEntries.isEmpty {
                                Text("No entries yet today")
                                    .font(.subheadline)
                                    .foregroundColor(.aquaWater)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Button {
                    showAddEntry = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.white, Color.aquaWater)
                }
                .padding(.top, 8)
            }
            .padding(.vertical, 24)
        }
        .background(Color.aquaBackground)
        .sheet(isPresented: $showAddEntry) {
            AddEntryView(viewModel: viewModel)
        }
    }
}

#Preview {
    DashboardView(viewModel: AquaCoreViewModel())
}
