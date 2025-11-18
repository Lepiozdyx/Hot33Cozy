import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    @State private var name = ""
    @State private var temperature = ""
    @State private var brewingTimeMinutes = ""
    @State private var ingredients = ""
    @State private var description = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageName = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.backgroundSurface)
                                    .frame(height: 120)
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(.textMuted)
                                    Text("Add Photo")
                                        .font(.bodyPrimary)
                                        .foregroundColor(.textSecondary)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Name")
                            TextField("Enter recipe name", text: $name)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .padding()
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Temperature")
                            TextField("e.g., 80°C", text: $temperature)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .padding()
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Brewing Time (minutes)")
                            TextField("e.g., 3", text: $brewingTimeMinutes)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Ingredients")
                            Text("One per line")
                                .font(.bodySecondary)
                                .foregroundColor(.textMuted)
                            TextEditor(text: $ingredients)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .frame(minHeight: 120)
                                .padding(8)
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                                .scrollContentBackground(.hidden)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Description")
                            TextEditor(text: $description)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .frame(minHeight: 120)
                                .padding(8)
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                                .scrollContentBackground(.hidden)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Add Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .foregroundColor(.textPrimary)
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        !name.isEmpty && !temperature.isEmpty && !brewingTimeMinutes.isEmpty
    }
    
    private func saveRecipe() {
        let ingredientsList = ingredients
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        let brewingTime = (Int(brewingTimeMinutes) ?? 0) * 60
        
        let recipe = Recipe(
            name: name,
            temperature: temperature,
            brewingTime: brewingTime,
            ingredients: ingredientsList,
            description: description,
            imageName: "custom-\(UUID().uuidString)",
            isCustom: true
        )
        
        dataManager.saveCustomRecipe(recipe)
        dismiss()
    }
}

#Preview {
    AddRecipeView()
        .environmentObject(DataManager.shared)
}

