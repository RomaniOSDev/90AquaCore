//
//  HistoryView.swift
//  90AquaCore
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: AquaCoreViewModel
    @State private var entryToEdit: HydrationEntry?
    @State private var showDeleteAlert = false
    @State private var entryToDelete: HydrationEntry?
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: Binding(
                    get: { viewModel.searchQuery },
                    set: { viewModel.searchQuery = $0 }
                ))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.aquaBackground)
                
                List {
                    ForEach(viewModel.filteredEntries) { entry in
                        HistoryRow(entry: entry, dateFormatter: dateFormatter)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                entryToEdit = entry
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    entryToDelete = entry
                                    showDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    entryToEdit = entry
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.aquaWater)
                            }
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white, Color.aquaBackground.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.aquaWater.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: Color.aquaDeep.opacity(0.04), radius: 4, x: 0, y: 2)
                    )
                    .listRowSeparatorTint(Color.aquaWater.opacity(0.3))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background(
                LinearGradient(
                    colors: [Color.aquaBackground, Color.aquaWater.opacity(0.04)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.light, for: .navigationBar)
            .sheet(item: $entryToEdit) { entry in
                EditEntryView(viewModel: viewModel, entry: entry)
            }
            .alert("Delete Entry", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    entryToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let e = entryToDelete {
                        viewModel.deleteEntry(e)
                    }
                    entryToDelete = nil
                }
            } message: {
                Text("Are you sure you want to delete this entry?")
            }
            .onChange(of: showDeleteAlert) { _, shown in
                if !shown { entryToDelete = nil }
            }
        }
    }
}

struct HistoryRow: View {
    let entry: HydrationEntry
    let dateFormatter: DateFormatter
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "drop.fill")
                .foregroundColor(.aquaWater)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(entry.amountML) ml")
                    .font(.headline)
                    .foregroundColor(.aquaDeep)
                if let intensity = entry.workoutIntensity {
                    Text(intensity.displayName)
                        .font(.caption)
                        .foregroundColor(.aquaWater)
                }
                if let note = entry.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: entry.date))
                .font(.caption)
                .foregroundColor(.aquaDeep)
        }
        .padding(.vertical, 4)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.aquaWater)
            TextField("Search by date, amount, note...", text: $text)
                .textFieldStyle(.plain)
                .tint(.aquaDeep)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.aquaWater.opacity(0.7))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color.aquaBackground.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.aquaWater.opacity(0.25), lineWidth: 1.5)
                )
                .shadow(color: Color.aquaDeep.opacity(0.06), radius: 6, x: 0, y: 3)
        )
    }
}

#Preview {
    HistoryView(viewModel: AquaCoreViewModel())
}
