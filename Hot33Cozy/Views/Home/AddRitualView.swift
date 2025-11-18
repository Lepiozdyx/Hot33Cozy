import SwiftUI
import PhotosUI

struct AddRitualView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var recipeManager: RecipeManager
    
    let onSave: (Ritual) -> Void
    
    @State private var title = ""
    @State private var notes = ""
    @State private var date = Date()
    @State private var temperature = ""
    @State private var brewingTimeMinutes = ""
    @State private var selectedRecipe: Recipe?
    @State private var showingRecipeSelection = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            VStack(spacing: 8) {
                                if let photoData, let uiImage = UIImage(data: photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(10)
                                } else {
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
                            }
                        }
                        .onChange(of: selectedPhoto) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    photoData = data
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Title")
                            TextField("Enter drink name", text: $title)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .padding()
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Notes")
                            TextEditor(text: $notes)
                                .font(.bodyPrimary)
                                .foregroundColor(.textSecondary)
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                                .scrollContentBackground(.hidden)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Date & Time")
                            DatePicker("", selection: $date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .colorScheme(.dark)
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
                            SectionHeader(title: "Select from Menu")
                            Button(action: { showingRecipeSelection = true }) {
                                HStack {
                                    Text(selectedRecipe?.name ?? "Choose a drink")
                                        .font(.bodyPrimary)
                                        .foregroundColor(selectedRecipe == nil ? .textMuted : .textSecondary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.textMuted)
                                }
                                .padding()
                                .background(Color.backgroundSurface)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Add Ritual")
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
                        saveRitual()
                    }
                    .foregroundColor(.textPrimary)
                    .disabled(finalTitle.isEmpty)
                }
            }
            .sheet(isPresented: $showingRecipeSelection) {
                RecipeSelectionView(selectedRecipe: $selectedRecipe)
            }
        }
    }
    
    private var finalTitle: String {
        if !title.isEmpty {
            return title
        }
        return selectedRecipe?.name ?? ""
    }
    
    private func saveRitual() {
        let brewingTime = Int(brewingTimeMinutes).map { $0 * 60 }
        
        let ritual = Ritual(
            title: finalTitle,
            notes: notes.isEmpty ? nil : notes,
            date: date,
            temperature: temperature.isEmpty ? nil : temperature,
            brewingTime: brewingTime,
            drinkID: selectedRecipe?.id,
            imageData: photoData
        )
        
        onSave(ritual)
        dismiss()
    }
}

#Preview {
    AddRitualView { _ in }
        .environmentObject(RecipeManager.shared)
}

