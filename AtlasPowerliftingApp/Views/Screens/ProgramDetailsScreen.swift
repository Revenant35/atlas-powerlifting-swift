//
//  ProgramDetailsScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ProgramDetailsScreen: View {
    @Bindable var program: WorkoutProgram

    @State private var selectedWeek: Int = 1
    @State private var selectedDay: DayOfWeek = .monday
    @State private var showingAddWorkout = false

    private var filteredWorkouts: [Workout] {
        program.workouts
            .filter { $0.week == selectedWeek && $0.dayOfWeek == selectedDay }
            .sorted { w1, w2 in
                // Sort by time of day (nil comes first)
                switch (w1.timeOfDay, w2.timeOfDay) {
                case (nil, nil): return false
                case (nil, _): return true
                case (_, nil): return false
                case let (t1?, t2?): return t1 < t2
                }
            }
    }

    private var markedDays: [DayOfWeek] {
        let daysWithWorkouts = program.workouts
            .filter { $0.week == selectedWeek }
            .map { $0.dayOfWeek }
        return Array(Set(daysWithWorkouts)).sorted()
    }

    var body: some View {
        VStack(spacing: 0) {
            // Program description (if present)
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

            // Week stepper
            WeekPicker(selectedWeek: $selectedWeek)
                .padding(.all)

            DayOfWeekPicker(selectedDay: $selectedDay, markedDays: markedDays)
                .padding(.all)

            // Content (rest day or workouts)
            Group {
                if filteredWorkouts.isEmpty {
                    // Rest Day View
                    ContentUnavailableView {
                        Label("Rest Day", systemImage: "bed.double.fill")
                    } description: {
                        Text("No workouts scheduled for \(selectedDay.rawValue) of Week \(selectedWeek)")
                    } actions: {
                        Button(action: { showingAddWorkout = true }) {
                            Text("Add Workout")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    // Inline Workouts View
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredWorkouts) { workout in
                                WorkoutCard(workout: workout)
                            }
                        }
                        .padding()
                    }
                }
            }
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
            AddWorkoutSheet(program: program, week: selectedWeek, day: selectedDay)
        }
    }
}

#Preview {
    let program = WorkoutProgram(
        name: "Starting Strength",
        programDescription: "A beginner strength training program focused on compound movements"
    )

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
    
    program.workouts = [workout1, workout2, workout3]

    return NavigationStack {
        ProgramDetailsScreen(program: program)
    }
}
