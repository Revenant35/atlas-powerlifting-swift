//
//  ProgramDetailView.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI
import SwiftData

struct ProgramDetailView: View {
    let program: WorkoutProgram

    var body: some View {
        Text("Program: \(program.name)")
            .navigationTitle(program.name)
    }
}

#Preview {
    let program = WorkoutProgram(name: "Starting Strength", programDescription: "A beginner strength training program")

    return NavigationStack {
        ProgramDetailView(program: program)
    }
}
