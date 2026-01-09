//
//  ProgramListScreen.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ProgramListScreen: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        sort: \WorkoutProgram.createdAt,
        order: .reverse
    )
    private var programs: [WorkoutProgram]

    @State private var searchQuery = ""
    @State private var showingAddProgram = false

    private var filteredPrograms: [WorkoutProgram] {
        if searchQuery.isEmpty {
            return programs
        }
        return programs.filter { program in
            program.name.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredPrograms.isEmpty {
                    NoPrograms(searchQuery: searchQuery)
                } else {
                    List {
                        ForEach(filteredPrograms) { program in
                            NavigationLink {
                                ProgramDetailsScreen(program: program)
                            } label: {
                                ProgramListItem(program: program)
                            }
                        }
                        .onDelete(perform: deletePrograms)
                    }
                }
            }
            .navigationTitle("Programs")
            .searchable(text: $searchQuery, prompt: "Search programs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddProgram = true }) {
                        Label("Add Program", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProgram) {
                AddProgramSheet()
            }
        }
    }
    
    private func deletePrograms(offsets: IndexSet) {
        withAnimation {
            let programs = offsets.map { filteredPrograms[$0] }
            withAnimation {
                programs.forEach(modelContext.delete)
            }
        }
    }
}


fileprivate struct NoPrograms: View {
    let searchQuery: String

    var body: some View {
        ContentUnavailableView(
            "No Programs",
            systemImage: "dumbbell.fill",
            description: Text(searchQuery.isEmpty ? "Create your first workout program to get started" : "No programs match '\(searchQuery)'")
        )
    }
}

fileprivate struct ProgramListItem: View {
    let program: WorkoutProgram

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(program.name)
                .font(.headline)
            Text("Created \(program.createdAt, format: .relative(presentation: .named))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview("With Programs") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WorkoutProgram.self, configurations: config)

    // Add sample data
    let program1 = WorkoutProgram(name: "Starting Strength", programDescription: "A beginner strength training program")
    let program2 = WorkoutProgram(name: "5/3/1", programDescription: "Wendler's 5/3/1 program")
    let program3 = WorkoutProgram(name: "PPL", programDescription: "Push Pull Legs routine")

    container.mainContext.insert(program1)
    container.mainContext.insert(program2)
    container.mainContext.insert(program3)

    return ProgramListScreen()
        .modelContainer(container)
}

#Preview("Empty List") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WorkoutProgram.self, configurations: config)

    return ProgramListScreen()
        .modelContainer(container)
}

