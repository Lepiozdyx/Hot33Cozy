import SwiftUI
import PhotosUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var dataManager: DataManager
    
    @FocusState private var isFocused: Bool
    
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
                        
                        UnderlinedTextField(label: "Name", text: $name, placeholder: "Enter recipe name")
                            .focused($isFocused)
                        
                        HStack(alignment: .top) {
                            UnderlinedTextField(label: "Temperature", text: $temperature, placeholder: "80°C", keyboardType: .numberPad)
                        
                            UnderlinedTextField(label: "Brewing Time", text: $brewingTimeMinutes, placeholder: "5 min", keyboardType: .numberPad)
                        }
                        .focused($isFocused)
                        
                        UnderlinedTextEditor(label: "Ingredients", text: $ingredients, placeholder: "...")
                            .focused($isFocused)

                        UnderlinedTextEditor(label: "Description", text: $description, placeholder: "...")
                            .focused($isFocused)
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
            .onTapGesture {
                isFocused = false
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
            id: dataManager.generateRecipeID(),
            name: name,
            temperature: temperature,
            brewingTime: brewingTime,
            ingredients: ingredientsList,
            description: description,
            imageName: "custom-recipe",
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

