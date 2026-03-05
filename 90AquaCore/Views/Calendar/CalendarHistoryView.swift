//
//  CalendarHistoryView.swift
//  90AquaCore
//

import SwiftUI

struct CalendarHistoryView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    @State private var selectedDate = Date()
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f
    }()
    
    private var monthDates: [Date] {
        guard let first = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)),
              let range = calendar.range(of: .day, in: .month, for: first) else {
            return []
        }
        return (0..<range.count).compactMap { calendar.date(byAdding: .day, value: $0, to: first) }
    }
    
    private var firstWeekdayOffset: Int {
        guard let first = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) else { return 0 }
        return calendar.component(.weekday, from: first) - 1
    }
    
    private var totalForDate: (Date) -> Int {
        { date in
            viewModel.entries
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + $1.amountML }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Calendar")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.aquaDeep)
                    .padding(.horizontal)
                
                HStack {
                    Button {
                        if let prev = calendar.date(byAdding: .month, value: -1, to: selectedDate) {
                            selectedDate = prev
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.aquaWater)
                            .font(.title2)
                    }
                    Spacer()
                    Text(dateFormatter.string(from: selectedDate))
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    Spacer()
                    Button {
                        if let next = calendar.date(byAdding: .month, value: 1, to: selectedDate) {
                            selectedDate = next
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.aquaWater)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .foregroundColor(.aquaDeep)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ForEach(0..<firstWeekdayOffset, id: \.self) { _ in
                        Color.clear
                            .frame(height: 44)
                    }
                    
                    ForEach(monthDates, id: \.self) { date in
                        CalendarDayCell(
                            date: date,
                            amount: totalForDate(date),
                            isToday: calendar.isDateInToday(date)
                        )
                    }
                }
                .aquaCard()
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Legend")
                        .font(.headline)
                        .foregroundColor(.aquaDeep)
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.aquaWater.opacity(0.3))
                                .frame(width: 12, height: 12)
                            Text("No data")
                                .font(.caption)
                                .foregroundColor(.aquaDeep)
                        }
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.aquaWater.opacity(0.6))
                                .frame(width: 12, height: 12)
                            Text("Some")
                                .font(.caption)
                                .foregroundColor(.aquaDeep)
                        }
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.aquaWater)
                                .frame(width: 12, height: 12)
                            Text("Goal met")
                                .font(.caption)
                                .foregroundColor(.aquaDeep)
                        }
                    }
                }
                .padding(.horizontal)
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
    }
}

struct CalendarDayCell: View {
    let date: Date
    let amount: Int
    let isToday: Bool
    
    private let calendar = Calendar.current
    
    private var intensity: Double {
        guard amount > 0 else { return 0 }
        let goal = 2500
        return min(1.0, Double(amount) / Double(goal))
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .aquaWater : .aquaDeep)
            
            if amount > 0 {
                Text("\(amount)")
                    .font(.system(size: 9))
                    .foregroundColor(.aquaWater)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.aquaWater.opacity(0.15 + intensity * 0.4),
                            Color.aquaWater.opacity(0.25 + intensity * 0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isToday ? Color.aquaWater : Color.aquaWater.opacity(0.1), lineWidth: isToday ? 2 : 1)
                )
                .shadow(color: Color.aquaDeep.opacity(0.04), radius: 2, x: 0, y: 1)
        )
    }
}

#Preview {
    CalendarHistoryView(viewModel: AquaCoreViewModel())
}
