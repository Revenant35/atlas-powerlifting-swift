//
//  EditExerciseSheet.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct EditExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var exercise: Exercise

    @State private var name: String
    @State private var exerciseDescription: String
    @State private var selectedMuscleGroups: [MuscleGroup]

    init(exercise: Exercise) {
        self.exercise = exercise
        _name = State(initialValue: exercise.name)
        _exerciseDescription = State(initialValue: exercise.exerciseDescription)
        _selectedMuscleGroups = State(initialValue: exercise.muscleGroups)
    }

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
            .navigationTitle("Edit Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveChanges() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = exerciseDescription.trimmingCharacters(in: .whitespaces)

        exercise.name = trimmedName
        exercise.exerciseDescription = trimmedDescription
        exercise.muscleGroups = selectedMuscleGroups
        exercise.updateTimestamp()

        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)

    let exercise = Exercise(
        name: "Squat",
        exerciseDescription: "A compound exercise targeting the lower body",
        muscleGroups: [.quads, .glutes]
    )
    container.mainContext.insert(exercise)

    return EditExerciseSheet(exercise: exercise)
        .modelContainer(container)
}
