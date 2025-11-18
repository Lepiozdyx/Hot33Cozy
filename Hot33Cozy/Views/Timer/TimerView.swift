import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @EnvironmentObject private var recipeManager: RecipeManager
    @State private var showingRecipeSelection = false
    
    init(presetTime: Int? = nil, drinkName: String = "", autoStart: Bool = false) {
        _viewModel = StateObject(wrappedValue: TimerViewModel(
            presetTime: presetTime,
            drinkName: drinkName,
            autoStart: autoStart
        ))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    TimerRing(
                        progress: viewModel.progress,
                        timeString: viewModel.timeString
                    )
                    
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.h2SectionTitle)
                                .foregroundColor(.textPrimary)
                            
                            Text(viewModel.drinkName.isEmpty ? "No drink selected" : viewModel.drinkName)
                                .font(.bodyPrimary)
                                .foregroundColor(viewModel.drinkName.isEmpty ? .textMuted : .textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Rectangle()
                                .fill(Color.divider)
                                .frame(height: 1)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.h2SectionTitle)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Add notes...", text: $viewModel.notes)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .disabled(viewModel.isRunning)
                            
                            Rectangle()
                                .fill(Color.divider)
                                .frame(height: 1)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Button(action: {
                        if viewModel.isRunning {
                            viewModel.stop()
                        } else {
                            viewModel.start()
                        }
                    }) {
                        Text(viewModel.isRunning ? "Stop" : "Start")
                    }
                    .buttonStyle(.primary)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                
                if viewModel.showCompletionOverlay {
                    Color.overlayScrim
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.accentYellow)
                        
                        Text("Timer Complete!")
                            .font(.h1ScreenTitle)
                            .foregroundColor(.textPrimary)
                        
                        Text("Your drink is ready")
                            .font(.bodyPrimary)
                            .foregroundColor(.textSecondary)
                    }
                    .padding(32)
                    .background(Color.backgroundSurface)
                    .cornerRadius(16)
                }
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingRecipeSelection = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showingRecipeSelection) {
                RecipeSelectionForTimerView(
                    onSelect: { recipe in
                        viewModel.selectDrink(recipe: recipe)
                    }
                )
            }
        }
    }
}

struct RecipeSelectionForTimerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var recipeManager: RecipeManager
    let onSelect: (Recipe) -> Void
    
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var filteredRecipes: [Recipe] {
        let allRecipes = recipeManager.allRecipes.sorted { $0.name < $1.name }
        
        if searchText.isEmpty {
            return allRecipes
        }
        return allRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                    .onTapGesture {
                        isSearchFocused = false
                    }
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textMuted)
                        
                        TextField("Search drinks...", text: $searchText)
                            .font(.bodyPrimary)
                            .foregroundColor(.textPrimary)
                            .focused($isSearchFocused)
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textMuted)
                            }
                        }
                    }
                    .padding()
                    .background(Color.backgroundSurface)
                    .cornerRadius(10)
                    .padding()
                    
                    List {
                        ForEach(filteredRecipes) { recipe in
                            Button(action: {
                                onSelect(recipe)
                                dismiss()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipe.name)
                                            .font(.h3CardTitle)
                                            .foregroundColor(.textPrimary)
                                        
                                        HStack(spacing: 12) {
                                            Text(recipe.temperature)
                                            Text("•")
                                            Text("\(recipe.brewingTime / 60)min")
                                        }
                                        .font(.bodySecondary)
                                        .foregroundColor(.textSecondary)
                                    }
                                    
                                    Spacer()
                                }
                            }
                            .listRowBackground(Color.backgroundSurface)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Select Drink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
            }
        }
    }
}

#Preview {
    TimerView()
        .environmentObject(RecipeManager.shared)
}

