//
//  EditableTextView.swift
//  Elephant
//
//  Created by 陸卉媫 on 5/22/25.
//

import SwiftUI

// Text object that allows user to edit it when on tap
struct EditableTextView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject var storage: TaskListStorage
    
    @State private var isEditing = false
    @Binding var task: TaskItem
    @FocusState private var isFocused: Bool
    
    let textColor: Color

    init(task: Binding<TaskItem>, textColor: Color? = nil) {
        self._task = task
        self.textColor = textColor ?? .black
    }

    var body: some View {
        
        if isEditing {
            TextField(task.title, text: $task.title, onCommit: {
                isEditing = false
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .focused($isFocused)
            .onAppear {
                isFocused = true
            }
        } else {
            Text(task.title)
                .onTapGesture {
                    isEditing = true
                }
                .strikethrough(task.isCompleted)
                .foregroundColor(textColor)
        }
    }
}
