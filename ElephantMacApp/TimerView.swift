//
//  TimerView.swift
//  Elephant
//
//  Created by 陸卉媫 on 5/5/25.
//

import Foundation
import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @AppStorage("curAvatar") private var curAvatar = "mammal-elephant"
    @AppStorage("timerMode") private var timerMode = "pomodoro"
    
    @EnvironmentObject var storage: TaskListStorage //for checklist access
    @EnvironmentObject var tokenLogic: TokenLogic //to modify tokens
    
    // checklist variables
    @State private var selectedChecklist: Checklist? = nil
    @State private var showingChecklist = false
    @State private var selectedTasks: [TaskItem] = []
    @State private var newTask: String = ""
    
    // token limit variables
    @AppStorage("todaysLimit") var todaysLimit: Int = 5
    @AppStorage("lastLimitUpdate") var lastLimitUpdate: Double = Date.now.timeIntervalSince1970
    
    @FocusState private var focusedTaskID: UUID?

    var body: some View {
        VStack{
            headerSection
            Image(curAvatar)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 170)
            
            if timerMode == "pomodoro"{
                PomodoroView()
            } else {
                StopwatchView()
            }
            
            ScrollView{
                VStack(alignment: .leading) {
                    WellnessTasklistView(checklistId: storage.curWellnessListId!)
                        .padding(.bottom)
                    TimerTasklistView(checklistId: storage.curChecklistId!)
                }
            }
            .padding(.bottom, 20)
        }
        .environmentObject(themeManager)
        .background(themeManager.curTheme.background_1)
        .accessibilityIdentifier("timerView")
        .frame(alignment: .center)
        .frame(width: 400, height: 500)
        .onAppear{
            storage.saveChecklists()
            tokenLogic.updateDailyLimit()
            storage.updateTaskList()
        }.onTapGesture {
            focusedTaskID = nil
        }
    }
    
    var headerSection: some View {
        HStack {
            VStack {
                Text("Current mode: \(timerMode)")
                    .padding(.leading, 20)
                    .font(.subheadline)
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(themeManager.curTheme.main_color_2)
                Text("Today's Token Limit: \(todaysLimit)")
                    .padding(.leading, 20)
                    .font(.subheadline)
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(themeManager.curTheme.main_color_2)
            }
            Spacer()
            ToHomePageButton() // Button to homepage
            ToSettingsPageButton() // Button to settings page
            ToManualPageButton() // Button to manual page
        }
        .padding([.top, .trailing], 15)
    }
}

struct WellnessTasklistView: View {
    var checklistId: UUID
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject var storage: TaskListStorage
    @EnvironmentObject var tokenLogic: TokenLogic
    
    var checklist: Checklist {
        storage.checklists.first(where: { $0.id == checklistId })!
    }
    
    // Delete item and wait for 2 secs before saving the change to storage
    func addNewWellnessTask(updatedTasks: [TaskItem], index: Int) {
        var updated = updatedTasks
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let newTask = storage.getNewWellnessTask()
            updated.remove(at: index)
            updated.append(TaskItem(title: newTask, isCompleted: false))
            storage.updateTasks(for: checklist.id,
                                tasks: updated)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            // work task list
//            if let checklist = storage.checklists.first(where: { $0.id == checklistId }) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(checklist.tasks.enumerated()), id: \.element.id) { index, task in
//                    let indices = checklist.tasks.enumerated().map { $0.offset }
//                    ForEach(indices, id: \.self) { index in
//                        let task = checklist.tasks[index]
                        HStack {
                            Image(systemName: task.isCompleted
                                  ? "heart.fill"
                                  : "heart")
                            .foregroundColor(task.isCompleted ? Color.red : themeManager.curTheme.main_color_2)
                            .onTapGesture {
                                
                                // Make a mutable copy of tasks and mark as complete
                                var updatedTasks = checklist.tasks
                                updatedTasks[index].isCompleted.toggle()

                                // If now completed, give the user a token
                                if updatedTasks[index].isCompleted {
                                    tokenLogic.addToken()
                                } else {
                                    tokenLogic.subtractToken()
                                }
                                
                                // update tasks so red heart shows
                                storage.updateTasks(for: checklist.id,
                                                        tasks: updatedTasks)
                                addNewWellnessTask(updatedTasks: updatedTasks, index: index)
                            }
                            EditableTextView(
                                task: Binding(
                                    get: { checklist.tasks[index] },
                                    set: {
                                        var updatedTasks = checklist.tasks
                                        updatedTasks[index] = $0
                                        storage.updateTasks(for: checklist.id, tasks: updatedTasks)
                                    }
                                )
                            )
                        }
                    }
                }
                .padding(.horizontal, 40)
//            }
        }
    }
}

struct TimerTasklistView: View {
    var checklistId: UUID
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject var storage: TaskListStorage
    @EnvironmentObject var tokenLogic: TokenLogic
    
    // checklist variables
    @State private var newTask: String = ""
    
    // adds new task to the specified tasklist
    func addNewTask(checklistId: UUID) {
        let trimmed = newTask.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        // Make sure we have a valid checklist to add to
        if storage.checklists.first(where: { $0.id == checklistId }) != nil {
            storage.addTask(to: checklistId, title: trimmed)
            newTask = "" // clear input after adding
        }
    }
    
    var body: some View {
        VStack(spacing: 15){
            // work task list
            if let checklist = storage.checklists.first(where: { $0.id == checklistId }) {
                VStack(alignment: .leading, spacing: 10) {
                    let indices = Array(0..<checklist.tasks.count)
                    ForEach(indices, id: \.self) { index in
                        let task = checklist.tasks[index]
                        HStack {
                            Image(systemName: task.isCompleted
                                  ? "checkmark.square.fill"
                                  : "square")
                            .foregroundColor(themeManager.curTheme.main_color_2)
                            .onTapGesture {
                                // Make a mutable copy of tasks
                                var updatedTasks = checklist.tasks
                                // Flip the isCompleted boolean
                                updatedTasks[index].isCompleted.toggle()
                                // Persist the change back into storage
                                storage.updateTasks(for: checklist.id,
                                                    tasks: updatedTasks)
                            }
                            EditableTextView(
                                task: Binding(
                                    get: { checklist.tasks[index] },
                                    set: {
                                        var updatedTasks = checklist.tasks
                                        updatedTasks[index] = $0
                                        storage.updateTasks(for: checklist.id, tasks: updatedTasks)
                                    }
                                )
                            )
                        }
                    }
                    //additional new task row
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(themeManager.curTheme.main_color_1)
                        TextField("Add new task...", text: $newTask)//, onCommit: addNewTask)// <- new task creation on '+'
                        //creates new task on enter
                            .onSubmit {
                                addNewTask(checklistId: checklist.id)
                            }
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(themeManager.curTheme.main_color_1)
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
let themeManager = ThemeManager()
    TimerView()
    .environmentObject(themeManager)
    .environmentObject(TaskListStorage())
    .environmentObject(TokenLogic())
}
