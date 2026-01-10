//
//  DayOfWeekPicker.swift
//  AtlasPowerliftingApp
//
//  Created by Zach Brown on 1/9/26.
//

import SwiftUI

fileprivate struct DayOfWeekPickerItem: View {
    let day: DayOfWeek
    let isSelected: Bool
    let isMarked: Bool
    
    var body: some View {
        VStack {
            Text(day.shortName)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)

            Circle()
                .fill(isMarked ? Color.accentColor : Color.clear)
                .frame(width: 4, height: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : Color.clear)
        )
    }
}

struct DayOfWeekPicker: View {
    @Binding var selectedDay: DayOfWeek

    let markedDays: [DayOfWeek]

    var body: some View {
        HStack {
            ForEach(DayOfWeek.allCases, id: \.self) { day in
                Button(action: {
                    selectedDay = day
                }) {
                    DayOfWeekPickerItem(
                        day: day,
                        isSelected: selectedDay == day,
                        isMarked: isMarked(day)
                    )
                }
                .buttonStyle(.plain)
                .foregroundColor(selectedDay == day ? .accentColor : .primary)
            }
        }
        .padding(.horizontal)
    }

    private func isMarked(_ day: DayOfWeek) -> Bool {
        markedDays.contains(day)
    }
}

#Preview {
    @Previewable @State var selectedDay: DayOfWeek = .monday
    
    let markedDays: [DayOfWeek] = [.monday, .wednesday, .friday]

    return DayOfWeekPicker(selectedDay: $selectedDay, markedDays: markedDays)
}
