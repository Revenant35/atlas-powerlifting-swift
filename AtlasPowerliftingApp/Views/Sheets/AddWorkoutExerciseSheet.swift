//
//  AddWorkoutExerciseSheet.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct AddWorkoutExerciseSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var workout: Workout

    @State private var selectedExercise: Exercise? = nil
    @State private var isRestTimeEnabled: Bool = false
    @State private var restTime: Int = 0
    @State private var warmupSets: Int = 0
    @State private var notes: String = ""

    private var isFormValid: Bool {
        selectedExercise != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                // Exercise Selection
                Section {
                    NavigationLink {
                        ExerciseSelectionList(selectedExercise: $selectedExercise)
                    } label: {
                        HStack {
                            Text("Exercise")
                            Spacer()
                            if let exercise = selectedExercise {
                                Text(exercise.name)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Select")
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }

                Section("Warm-up") {
                    Stepper(
                        "Warm-up Sets: \(warmupSets)",
                        value: $warmupSets,
                        in: 0...16,
                        step: 1)
                }

                Section("Rest Time") {
                    Toggle("Enable Rest Time", isOn: $isRestTimeEnabled)

                    if isRestTimeEnabled {
                        RestTimePicker(totalSeconds: $restTime)
                    }
                }

                Section {
                    TextField("Notes (Optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                        .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createWorkoutExercise()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }

    private func createWorkoutExercise() {
        guard let exercise = selectedExercise else { return }

        let trimmedNotes = notes.trimmingCharacters(in: .whitespaces)
        let finalRestTime = isRestTimeEnabled ? restTime : 0

        withAnimation {
            // Calculate next order
            let nextOrder = (workout.exercises.map { $0.order }.max() ?? 0) + 1

            let newWorkoutExercise = WorkoutExercise(
                exercise: exercise,
                order: nextOrder,
                restTime: finalRestTime,
                warmupSets: warmupSets,
                notes: trimmedNotes,
                workout: workout
            )

            workout.exercises.append(newWorkoutExercise)
        }

        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Workout.self,
        Exercise.self,
        configurations: config
    )

    // Create sample exercise
    let exercise = Exercise(
        name: "Squat",
        exerciseDescription: "Barbell back squat",
        muscleGroups: [.quads, .glutes]
    )
    container.mainContext.insert(exercise)

    let workout = Workout(
        name: "Starting Strength",
        workoutDescription: "",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: nil
    )

    return AddWorkoutExerciseSheet(workout: workout)
        .modelContainer(container)
}
