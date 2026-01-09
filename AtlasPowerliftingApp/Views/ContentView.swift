//
//  ContentView.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            ProgramListScreen()
                .tabItem {
                    Label("Programs", systemImage: "list.bullet")
                }

            ExerciseListScreen()
                .tabItem {
                    Label("Exercises", systemImage: "dumbbell")
                }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WorkoutProgram.self, configurations: config)

    // Add sample data
    let program1 = WorkoutProgram(name: "Starting Strength", programDescription: "A beginner strength training program")
    let program2 = WorkoutProgram(name: "5/3/1", programDescription: "Wendler's 5/3/1 program")
    let program3 = WorkoutProgram(name: "PPL", programDescription: "Push Pull Legs routine")

    container.mainContext.insert(program1)
    container.mainContext.insert(program2)
    container.mainContext.insert(program3)

    return ContentView()
        .modelContainer(container)
}
