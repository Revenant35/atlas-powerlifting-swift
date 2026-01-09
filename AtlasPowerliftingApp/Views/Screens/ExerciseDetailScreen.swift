//
//  ExerciseDetailScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ExerciseDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Bindable var exercise: Exercise

    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false

    var body: some View {
        List {
            if !exercise.exerciseDescription.isEmpty {
                Section("Description") {
                    Text(exercise.exerciseDescription)
                }
            }

            if !exercise.muscleGroups.isEmpty {
                Section("Muscle Groups") {
                    ForEach(exercise.muscleGroups, id: \.self) { muscleGroup in
                        Text(muscleGroup.rawValue)
                    }
                }
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingEditSheet = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditExerciseSheet(exercise: exercise)
        }
        .alert("Delete Exercise", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteExercise()
            }
        } message: {
            Text("Are you sure you want to delete \"\(exercise.name)\"? This action cannot be undone.")
        }
    }

    private func deleteExercise() {
        withAnimation {
            modelContext.delete(exercise)
        }
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Exercise.self, configurations: config)

    let exercise = Exercise(
        name: "Squat",
        exerciseDescription: "A compound exercise targeting the lower body, primarily the quads, glutes, and hamstrings.",
        muscleGroups: [.quads, .glutes, .hamstrings]
    )
    container.mainContext.insert(exercise)

    return NavigationStack {
        ExerciseDetailScreen(exercise: exercise)
            .modelContainer(container)
    }
}
