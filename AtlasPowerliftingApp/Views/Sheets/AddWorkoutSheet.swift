//
//  AddWorkoutSheet.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct AddWorkoutSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let program: WorkoutProgram
    let initialWeek: Int

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var week: Int
    @State private var dayOfWeek: DayOfWeek = .monday
    @State private var includeTimeOfDay: Bool = false
    @State private var timeOfDay: TimeOfDay = .morning

    init(program: WorkoutProgram, initialWeek: Int = 1) {
        self.program = program
        self.initialWeek = initialWeek
        _week = State(initialValue: initialWeek)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Workout Name", text: $name)
                        .textInputAutocapitalization(.words)
                }

                Section {
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                        .textInputAutocapitalization(.sentences)
                }

                Section("Schedule") {
                    Stepper("Week \(week)", value: $week, in: 1...52)

                    Picker("Day of Week", selection: $dayOfWeek) {
                        ForEach(DayOfWeek.allCases, id: \.self) { day in
                            Text(day.rawValue).tag(day)
                        }
                    }

                    Toggle("Specify Time of Day", isOn: $includeTimeOfDay)

                    if includeTimeOfDay {
                        Picker("Time of Day", selection: $timeOfDay) {
                            ForEach(TimeOfDay.allCases, id: \.self) { time in
                                Text(time.rawValue).tag(time)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createWorkout()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func createWorkout() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = description.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else { return }

        withAnimation {
            let newWorkout = Workout(
                name: trimmedName,
                workoutDescription: trimmedDescription,
                week: week,
                dayOfWeek: dayOfWeek,
                timeOfDay: includeTimeOfDay ? timeOfDay : nil,
                program: program
            )
            modelContext.insert(newWorkout)
        }

        dismiss()
    }
}

#Preview {
    let program = WorkoutProgram(name: "Starting Strength", programDescription: "")

    return AddWorkoutSheet(program: program, initialWeek: 2)
        .modelContainer(for: WorkoutProgram.self, inMemory: true)
}
