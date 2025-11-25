import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingAddRitual = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                if viewModel.rituals.isEmpty {
                    EmptyStateView(
                        icon: "cup.and.saucer",
                        title: "No Rituals Yet",
                        message: "Start tracking your warm beverage moments by tapping the + button above."
                    )
                } else {
                    List {
                        ForEach(viewModel.groupedRituals(), id: \.0) { section, rituals in
                            Section {
                                ForEach(rituals) { ritual in
                                    NavigationLink(destination: RitualDetailView(ritual: ritual)) {
                                        RitualRowView(ritual: ritual)
                                    }
                                }
                                .onDelete { indexSet in
                                    indexSet.forEach { index in
                                        viewModel.deleteRitual(rituals[index])
                                    }
                                }
                            } header: {
                                Text(section)
                                    .font(.h2SectionTitle)
                                    .foregroundColor(.textPrimary)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.automatic)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("My Rituals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddRitual = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingAddRitual) {
                AddRitualView { ritual in
                    viewModel.saveRitual(ritual)
                }
            }
            .onAppear {
                viewModel.loadRituals()
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 100)
            }
        }
    }
}

struct RitualRowView: View {
    let ritual: Ritual
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(ritual.title)
                    .font(.h3CardTitle)
                    .foregroundColor(.textPrimary)
                
                if let notes = ritual.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.bodySecondary)
                        .foregroundColor(.textSecondary)
                        .italic()
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text(ritual.date, style: .time)
                .font(.h3CardTitle)
                .foregroundColor(.textPrimary)
        }
    }
}

#Preview {
    HomeView()
}

