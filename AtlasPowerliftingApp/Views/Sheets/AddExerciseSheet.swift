//
//  AddExerciseSheet.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct AddExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name: String = ""
    @State private var exerciseDescription: String = ""
    @State private var selectedMuscleGroups: [MuscleGroup] = []

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Exercise Name", text: $name)
                        .textInputAutocapitalization(.words)
                }

                Section {
                    TextField("Description (Optional)", text: $exerciseDescription, axis: .vertical)
                        .lineLimit(3...6)
                        .textInputAutocapitalization(.sentences)
                }

                Section("Muscle Groups") {
                    NavigationLink {
                        MuscleGroupSelectionList(selectedMuscleGroups: $selectedMuscleGroups)
                    } label: {
                        HStack {
                            Text("Muscle Groups")
                            Spacer()
                            if selectedMuscleGroups.isEmpty {
                                Text("None")
                                    .foregroundStyle(.tertiary)
                            } else {
                                Text("\(selectedMuscleGroups.count) selected")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createExercise()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func createExercise() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = exerciseDescription.trimmingCharacters(in: .whitespaces)

        withAnimation {
            let newExercise = Exercise(
                name: trimmedName,
                exerciseDescription: trimmedDescription,
                muscleGroups: selectedMuscleGroups
            )
            modelContext.insert(newExercise)
        }

        dismiss()
    }
}

#Preview {
    AddExerciseSheet()
        .modelContainer(for: Exercise.self)
}
