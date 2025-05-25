//
//  ChecklistMainPageView.swift
//  Elephant
//
//  Created by Medhashree Adhikari on 5/3/25.
//  Edited by Gabby Pruneda Turcios
//
//    reference source for selection list: //https://github.com/yonat/SelectionList/blob/master/Sources/SelectionList.swift

import SwiftUI

struct ChecklistMainPageView: View {
    @State private var isPressed = false //boolean to check if button has been pressed
    @State private var showingChecklist = false //boolean to show pop-up sheet for checklist view
    @State private var curChecklistId: UUID? = nil //current checklist id
    @State private var selectedChecklist: Checklist? = nil //selected checklist
    @State private var showingNewList = false //boolean to show new checklist
    @State private var newListName = "" //initial empty string for new list name
    @State private var editingListId: UUID? = nil //edited checklist new id
    @State private var editListName = "" //initial edited list name
    @State private var showDeletion = false //boolean set to show checklist deletion
    @State private var deleteListId: UUID? = nil //id of deleted checklist for storage
    
    @State private var displayedTasks: [TaskItem] = [] //array of task items displayed for each checklist
    
    @EnvironmentObject var storage: TaskListStorage //storage for task items using TaskListStorage and TaskModel
    @EnvironmentObject var themeManager: ThemeManager //incorporate theme and modal changes within this view
    @EnvironmentObject var tokenLogic: TokenLogic //calls token logic from TokenLogic.swift
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    //introduction text
                    Text("Checklists")
                        .kerning(2)
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
//                        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.background_1))
                        .foregroundColor(themeManager.curTheme.text_1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                    
                    Spacer()
                    ToHomePageButton() // Button to homepage
                    ToSettingsPageButton() // Button to settings page
                    ToManualPageButton() // Button to manual page
                }
                .padding([.top, .trailing], 15)

                
                //displays all existing checklists
                ForEach(storage.checklists) { checklist in
                    checklistButton(for: checklist) //calls func for checklist creation
                        .onTapGesture { //displays selected checklist on user action
                            selectedChecklist = checklist
                        }
                }
                
                // New list button
                ElephantButton(
                    buttonText: "New Checklist",
                    buttonImage: "plus.circle.fill",
                    action: {
                        showingNewList = true
                    },
                    color: themeManager.curTheme.main_color_2
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .padding(.top, 10)
            }
        }//displays pop up checklist on user command
        .sheet(item: $selectedChecklist){ checklist in
            NavigationView {
                CheckListView(
                    checklistId: checklist.id,
                    checklistName: checklist.name,
                    initialTasks: checklist.tasks
                )
                .environmentObject(storage)
                .environmentObject(themeManager)
                .environmentObject(tokenLogic)
            }
            .frame(width: 400, height: 500)
        }//prompt for user entering new checklist name
        .alert("Create New Checklist", isPresented: $showingNewList) {
            TextField("Checklist Name", text: $newListName)
            
            Button("Cancel", role: .cancel) {
                newListName = ""
            }
            //cleans up user input string for list name
            Button("Create") {
                let trimmedName = newListName.trimmingCharacters(in: .whitespaces)
                if !trimmedName.isEmpty {
                    storage.addChecklist(name: trimmedName) //adds checklist to strorage
                    newListName = ""
                }
            }
        }//prompt for users to rename checklist names after creation
        .alert("Rename Checklist", isPresented: Binding(get: {
            editingListId != nil
        }, set: {
            if !$0 { editingListId = nil }
        })) {//prompt to enter new checklist name
            TextField("New name", text: $editListName)
            //dismisses any unsaved changes
            Button("Cancel", role: .cancel) {
                editingListId = nil
                editListName = ""
            }
            //cleans up user input string for renaming
            Button("Rename") {
                if let id = editingListId {
                    let trimmedName = editListName.trimmingCharacters(in: .whitespaces)
                    if !trimmedName.isEmpty {
                        storage.renameChecklist(id: id, newName: trimmedName) //stores renamed checklist at that current checklist id
                        editingListId = nil
                        editListName = ""
                    }
                }
            }
        }//prompt for users when deleting checklist on user request
        .alert("Delete Checklist", isPresented: $showDeletion) {
            Button("Cancel", role: .cancel) {
                deleteListId = nil
            }
            
            Button("Delete", role: .destructive) {
                if let id = deleteListId {
                    storage.removeChecklist(id: id) //removes checklist from user view
                    deleteListId = nil
                }
            }
        } message: { //prompt to make sure user meant to make checklist deletion (not yet able to retrieve deleted checklists)
            Text("Are you sure you want to delete this checklist? This action cannot be undone :(")
        }
        .padding()
        .preferredColorScheme(themeManager.Mode ? .dark : .light)
        .background(themeManager.curTheme.background_1)
        .frame(width: 400, height: 500)
        .accessibilityIdentifier("checklistsMainPage")
    }
    //initial view of new checklist buttons
    private func checklistButton(for checklist: Checklist) -> some View {
        HStack {
                HStack {
                    Text(checklist.name) //displays checklist name
                        .font(.system(.title3, design: .rounded).weight(.medium))
                        // .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1))
                        .foregroundColor(themeManager.curTheme.text_1)
                    
                    Spacer()
                    
                    Text("\(checklist.tasks.filter { $0.isCompleted }.count)/\(checklist.tasks.count)") //displays number of completed tasks/total tasks
                        .font(.system(.subheadline, design: .rounded))
                        // .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1).opacity(0.7))
                        .foregroundColor(themeManager.curTheme.text_1.opacity(0.7))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(themeManager.curTheme.main_color_1))
            
            // Edit button for checklist renaming
            ElephantButton(
                buttonText: "Edit",
                buttonImage: "pencil",
                action: {
                    editingListId = checklist.id
                    editListName = checklist.name
                },
                color: themeManager.curTheme.main_color_2)
            
            // Delete button for checklist
            ElephantButton(
                buttonText: "Delete",
                buttonImage: "trash",
                action: {
                    deleteListId = checklist.id
                    showDeletion = true
                },
                color: themeManager.curTheme.main_color_2)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
    }
}

// CheckListView
struct CheckListView: View {
    @EnvironmentObject var tokenLogic: TokenLogic //calls token logic from TokenLogic.swift
    @Environment(\.dismiss) private var dismiss //dismiss current view
    @EnvironmentObject var storage: TaskListStorage //storage for task items using TaskListStorage and TaskModel
    @EnvironmentObject var themeManager: ThemeManager //for theme and modal changes
    
    let checklistId: UUID //initializes checklist id
    let onCancel: () -> Void // added to support inline checklist view
    @State private var checklistName: String //checklist name string
    @State private var isEditing: Bool = false //boolean that checks if we're editing the checklist
    @State private var changedName: String = "" //changed checklist name
    @State private var newTask: String = "" //initial empty str for new task
    

    @State private var localTasks: [TaskItem] //array of stored local tasks
    @State private var hasChanged: Bool = false //boolean to determine if the checklist has been changed (add/delete tasks)
    
    // Pass initial tasks through init to avoid fetching during view creation
    init(checklistId: UUID, checklistName: String, initialTasks: [TaskItem], onCancel: @escaping () -> Void = {}) {
        self.checklistId = checklistId
        self._checklistName = State(initialValue: checklistName)
        self._localTasks = State(initialValue: initialTasks)
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Checklist title with edit functionality
            HStack {
                if isEditing {//prompt for user to enter new checklist name
                    TextField("Checklist Name", text: $changedName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
//                        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_2))
                        .foregroundColor(themeManager.curTheme.text_1)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .padding(.horizontal)
                    //save button for changes
                    ElephantButton(
                        buttonText: "Save",
                        action: saveChecklistName,
                        color: themeManager.curTheme.main_color_2
                    )
                    .padding(.trailing)
                } else { //displays currently selected checklist
                    Text(checklistName)
                        .font(.title2)
                        .fontWeight(.bold)
//                        .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_2))
                        .foregroundColor(themeManager.curTheme.text_2)
                        .fontDesign(.rounded)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            taskList //displays task list within checklist view
            
            Spacer()
            
            actionButtons //cancel and save buttons
        }
        .padding()
        .cornerRadius(12)
        .padding()
    }
    //displays task list for currently selected checklist
    private var taskList: some View {
        List {
            if localTasks.isEmpty { //displays default message for empty checklist
                Text("No tasks yet!")
                    .foregroundColor(themeManager.curTheme.main_color_2)
                    .padding(10)
                    .listRowBackground(themeManager.curTheme.background_1)
            } else { //displays added task list items
                ForEach(localTasks) { task in
                    taskRow(for: task) //line for each task item in checklist
                } //removes task from array of locally stored tasks
                .onDelete { indexSet in
                    localTasks.remove(atOffsets: indexSet)
                    hasChanged = true
                }
            }
            
            //additional new task row
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(themeManager.curTheme.main_color_1)
                TextField("Add new task...", text: $newTask)//, onCommit: addNewTask)// <- new task creation on '+'
                //creates new task on enter
                    .onSubmit {
                        addNewTask()
                    }
                    .textFieldStyle(PlainTextFieldStyle())
//                    .foregroundColor(themeManager.textColor(for: themeManager.curTheme.main_color_1))
                    .foregroundColor(themeManager.curTheme.main_color_1)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    //task row for individual checklist task items view
    private func taskRow(for task: TaskItem) -> some View {
        HStack { //display for completed or newly created task list
            Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
//                .foregroundColor(task.isCompleted ? themeManager.curTheme.main_color_2 : themeManager.curTheme.main_color_3)
                .foregroundColor(themeManager.curTheme.main_color_2)
                .onTapGesture { //sets task as completed on user selection
                    if let index = localTasks.firstIndex(where: { $0.id == task.id }) {
                        localTasks[index].isCompleted.toggle()
                        storage.removeTask(task: task)
                        if localTasks[index].isCompleted{ //only adds token if completed a task 
                            tokenLogic.addToken() //adds token when a task item is marked as completed
                        }
                        // if unchecked, subtract token
                        if !localTasks[index].isCompleted {
                            tokenLogic.subtractToken()
                        }
                        hasChanged = true
                    }
                    //toggleTask(task)
                }
            //displays newly created task and pushes onto queue list of task items
            Text(task.title)
                .strikethrough(task.isCompleted)//crosses out task title once completed
                .foregroundColor(task.isCompleted ? themeManager.curTheme.main_color_2 : themeManager.curTheme.main_color_3)
        }
    }
    //cancel and save buttons for task items
    private var actionButtons: some View {
        HStack(spacing: 20) {
            ElephantButton(
                buttonText: "Cancel",
                action: { dismiss() },
                color: themeManager.curTheme.main_color_2
            )
            
            ElephantButton(
                buttonText: "Save",
                action: saveChanges, //saves newly updated tasks
                color: themeManager.curTheme.main_color_1
            )
        }
        .padding(.bottom)
    }
    
    //saves changes made to task list
    private func saveChanges() {
        //if checklist was changed, we update the tasks
        if hasChanged{
            storage.updateTasks(for: checklistId, tasks: localTasks) //updates tasks from TaskListStorage
        }
        
        if !changedName.isEmpty && checklistName != changedName {
            storage.renameChecklist(id: checklistId, newName: checklistName) //renames checklist name and saves new name
        }
        
        dismiss() //goes back to checklist main page view after hitting save
    }
    
    //adds new task
    private func addNewTask() {
        //cleans up string entry before appending to local task items
        let trim = newTask.trimmingCharacters(in: .whitespaces)
        guard !trim.isEmpty else { return }
        
        let newItem = TaskItem(title: trim)
        localTasks.append(newItem)
        hasChanged = true
        
        // Use main thread for UI updates
        DispatchQueue.main.async {
            self.newTask = ""
        }
    }
    //saves new checklist name
    private func saveChecklistName() {
        //cleans up string name before editing the checklist name
        let trimmedName = changedName.trimmingCharacters(in: .whitespaces)
        if !trimmedName.isEmpty {
            checklistName = trimmedName
            storage.renameChecklist(id: checklistId, newName: trimmedName)
            hasChanged = true
        }
        isEditing = false //sets editing back to false after changes have been made
    }
}

#Preview {
    let themeManager = ThemeManager()
    ChecklistMainPageView()
        .environmentObject(themeManager)
        .environmentObject(TaskListStorage())
        .environmentObject(TokenLogic())
}

