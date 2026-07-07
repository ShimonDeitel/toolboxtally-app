import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var editingEntry: ToolEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button {
                        editingEntry = entry
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.name.isEmpty ? "Untitled" : entry.name)
                                .font(Theme.headingFont)
                                .foregroundStyle(.primary)
                            Text(entry.storageSpot)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Toolbox Tally")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntrySheet(isPresented: $showingAdd)
            }
            .sheet(item: $editingEntry) { entry in
                AddEntrySheet(isPresented: .constant(true), editing: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $store.showPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No tools yet", systemImage: "tray", description: Text("Tap + to add your first tool."))
                }
            }
        }
        .tint(Theme.primary)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var editing: ToolEntry?

    @State private var name: String = ""
    @State private var storageSpot: String = ""
    @State private var borrowedBy: String = ""
    @State private var notes: String = ""

    init(isPresented: Binding<Bool>, editing: ToolEntry? = nil) {
        self._isPresented = isPresented
        self.editing = editing
        if let e = editing { _name = State(initialValue: e.name) }
        if let e = editing { _storageSpot = State(initialValue: e.storageSpot) }
        if let e = editing { _borrowedBy = State(initialValue: e.borrowedBy) }
        if let e = editing { _notes = State(initialValue: e.notes) }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("addNameField")
                TextField("Storage spot", text: $storageSpot)
                    .accessibilityIdentifier("addStorageSpotField")
                TextField("Borrowed by", text: $borrowedBy)
                    .accessibilityIdentifier("addBorrowedByField")
                TextField("Notes", text: $notes)
                    .accessibilityIdentifier("addNotesField")
            }
            .navigationTitle(editing == nil ? "Add Tool" : "Edit Tool")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false; dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if var e = editing {
                            e.name = name
                            e.storageSpot = storageSpot
                            e.borrowedBy = borrowedBy
                            e.notes = notes
                            store.update(e)
                        } else {
                            let entry = ToolEntry(name: name, storageSpot: storageSpot, borrowedBy: borrowedBy, notes: notes)
                            let added = store.add(entry, isPro: purchases.isPro)
                            if !added { return }
                        }
                        isPresented = false
                        dismiss()
                    }
                    .accessibilityIdentifier("addSaveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
