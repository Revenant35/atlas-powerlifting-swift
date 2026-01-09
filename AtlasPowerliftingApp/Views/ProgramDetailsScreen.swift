//
//  ProgramDetailsScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ProgramDetailsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var programs: [WorkoutProgram]
    @Query private var allWorkouts: [Workout]
    @State private var selectedWeek: Int = 1
    @State private var showingAddWorkout = false

    let programID: PersistentIdentifier

    private var program: WorkoutProgram? {
        programs.first { $0.persistentModelID == programID }
    }

    private var programWorkouts: [Workout] {
        allWorkouts.filter { $0.program?.persistentModelID == programID }
    }

    private var availableWeeks: [Int] {
        let weeks = Set(programWorkouts.map { $0.week })
        return weeks.sorted()
    }

    private var filteredWorkouts: [Workout] {
        programWorkouts.filter { $0.week == selectedWeek }
    }

    var body: some View {
        Group {
            if let program = program {
                VStack(spacing: 0) {
                    if !program.programDescription.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text(program.programDescription)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGroupedBackground))
                    }

                    if !availableWeeks.isEmpty {
                        Picker("Week", selection: $selectedWeek) {
                            ForEach(availableWeeks, id: \.self) { week in
                                Text("Week \(week)").tag(week)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    }

                    WorkoutsList(workouts: filteredWorkouts)
                }
                .navigationTitle(program.name)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showingAddWorkout = true }) {
                            Label("Add Workout", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddWorkout) {
                    AddWorkoutSheet(program: program, initialWeek: selectedWeek)
                }
                .onAppear {
                    if let firstWeek = availableWeeks.first {
                        selectedWeek = firstWeek
                    }
                }
            } else {
                ContentUnavailableView(
                    "Program Not Found",
                    systemImage: "exclamationmark.triangle",
                    description: Text("This program may have been deleted")
                )
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WorkoutProgram.self, Workout.self, configurations: config)

    let program = WorkoutProgram(name: "Starting Strength", programDescription: "A beginner strength training program focused on compound movements")

    let workout1 = Workout(
        name: "Workout A",
        workoutDescription: "Squat, Bench, Deadlift",
        week: 1,
        dayOfWeek: .monday,
        timeOfDay: .morning,
        program: program
    )
    let workout2 = Workout(
        name: "Workout B",
        workoutDescription: "Squat, Press, Power Clean",
        week: 1,
        dayOfWeek: .wednesday,
        timeOfDay: .morning,
        program: program
    )
    let workout3 = Workout(
        name: "Workout A",
        workoutDescription: "Squat, Bench, Deadlift",
        week: 1,
        dayOfWeek: .friday,
        timeOfDay: .morning,
        program: program
    )

    container.mainContext.insert(program)
    container.mainContext.insert(workout1)
    container.mainContext.insert(workout2)
    container.mainContext.insert(workout3)

    return NavigationStack {
        ProgramDetailsScreen(programID: program.persistentModelID)
    }
    .modelContainer(container)
}
