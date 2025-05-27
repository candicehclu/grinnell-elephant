//
//  TaskListStorage.swift
//  Elephant: A Wellness Trunk
//
//  Created by Pruneda Turcios, Gabriela (Gabby) on 4/6/25.
//
// TODO:
// 1. have a storage of wellness tasks that cannot be deleted entirely, but can be edited
// 2. have one single task list that cannot be deleted but can be edited
// 3. data structure:
//      a. default work task list
//      b. default wellness task list
//      c. a list to store all wellness tasks (can be edited)

import SwiftUI
import Foundation

//struct for individual checklist initialization
struct Checklist: Identifiable, Codable {
    var id = UUID()
    var name: String
    var tasks: [TaskItem]
    var canDelete: Bool = true
}

var GrinnellStudyBreaks = [
    "Drink a cup of water",
    "Go for a quick walk around campus",
    "Stretch for three minutes",
    "Get a drink and snacks at DSA suite (JRC 3rd)",
    "Get coffee at Saints rest",
    "Get ice cream at Dari Barn",
    "Chill at the hammocks",
    "Play a game (pool/foosball/ping pong) at game room",
    "Admire the beauty of sunset"
]

//TaskListStorage stores tasks objects to file TaskLists.json
class TaskListStorage: ObservableObject{
    private let tasksFilename = "TaskLists.json"
    private let checklistsFilename = "Checklists.json"
    
    // tracks last update time
    @AppStorage("lastTasklistUpdate") var lastTasklistUpdate: Double = 0.0
    
    // current checklist showed on timer page
    @Published var curChecklistId: UUID? = nil // default work task list (shown on timerview)
    @Published var curWellnessListId: UUID? = nil // default wellness task list (shown on timerview), randomly takes tasks from wellnessTaskStorage
    @Published var wellnessTaskStorageId: UUID? = nil // list of wellness tasks, can be edited but doesn't show on timerview
    
    @Published var taskList = TaskList(tasks: []){ //saves current task list
        didSet{
            saveTasks()//updates tasks
        }
    }
    
    @Published var checklists: [Checklist] = [] {
        didSet {
            saveChecklists()
        }
    }
    
    // update the last time the tasklist was updated
    func updateTaskList() {
        let calendar = Calendar.current
        let timeZone = TimeZone.current
        
        let components = calendar.dateComponents(in: timeZone, from: Date())
        let today = components.date
        let lastUpdateDate = NSDate(timeIntervalSince1970: lastTasklistUpdate)
        // if not same day, delete all tasks that are completed
        if !Calendar.current.isDate(today ?? Date.now, inSameDayAs: lastUpdateDate as Date) {
            lastTasklistUpdate = today!.timeIntervalSince1970
            for checklist in checklists {
                for task in checklist.tasks {
                    if task.isCompleted {
                        removeTask(from: checklist.id, task: task)
                    }
                }
            }
        }
    }
    
    init(){
        loadTasks() // loads tasks for user view
        loadChecklists() //loads all currently existing checklists
        
        // use this to reset checklist storage!
//        if !checklists.isEmpty {
//            checklists = []
            
        // first time: initialize checklists
        if checklists.isEmpty {
            // list of all wellness items
            let wellnessTaskStorage = Checklist(name: "Grinnell study breaks!", tasks: [], canDelete: false)
            checklists.append(wellnessTaskStorage)
            for task in GrinnellStudyBreaks {
                addTask(to: wellnessTaskStorage.id, title: task, isWellness: true)
            }
            wellnessTaskStorageId = wellnessTaskStorage.id
            saveChecklists()
            
            // list of wellness tasks (shown on timer page) with three random things to begin with
            let wellnessChecklist = Checklist(name: "Wellness tasks", tasks: [], canDelete: false)
            checklists.append(wellnessChecklist)
            // shuffle tasks and get first three
            let shuffled = checklists.first(where: { $0.id == wellnessTaskStorageId })!.tasks.shuffled()
            let randomPicks = shuffled.prefix(3)
            print("adding tasks to wellness list")
            for task in randomPicks {
                print(task.title)
                print("supposed to print")
                addTask(to: wellnessChecklist.id, title: task.title, isWellness: true)
            }
            curWellnessListId = wellnessChecklist.id
            
            // list of work tasks (shown on timer page)
            let workChecklist = Checklist(name: "Work tasks", tasks: [], canDelete: false)
            checklists.append(workChecklist)
            curChecklistId = workChecklist.id
            addTask(to: curChecklistId!, title: "Get signature for MAP application")
            addTask(to: curChecklistId!, title: "Fix bug in Elephant App")
            saveChecklists()
        }
    }
    
    private func getTasksFile() -> URL? { //retrieves the TaskLists.json file and creates a direct path to append new tasks
        guard let direct = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return nil
        }
        return direct.appendingPathComponent(tasksFilename) //returns direct path to file
    }
    
    private func getListsFile() -> URL? { //retrieves the Checklists.json file and creates a direct path to append new checklists
        guard let direct = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
            return nil
        }
        return direct.appendingPathComponent(checklistsFilename) //returns direct path to file
    }
    
    func loadTasks(){ //shows task list to the user in settings
        guard let file = getTasksFile() else {return} //exits if the file is not accesed
        
        do{
            let data = try Data(contentsOf: file)
            let decodedList = try JSONDecoder().decode(TaskList.self, from: data)
            taskList = decodedList
        } catch {
            print("Error loading tasks, default list shown")
        }
    }
    
    //saves new tasks to the taskList encoding through the defined path
    func saveTasks(){
        guard let file = getTasksFile() else {return} //exits if the file is not accesed
        
        do{
            let data = try JSONEncoder().encode(taskList)
            try data.write(to: file)
        }catch{
            print("Error: failed to save tasks")
        }
    }
    
    //loads checklists from file
    func loadChecklists(){
        guard let file = getListsFile() else {return}
        
        do{
            if FileManager.default.fileExists(atPath: file.path){
                let data = try Data(contentsOf: file)
                let decodedLists = try JSONDecoder().decode([Checklist].self, from: data)
                checklists = decodedLists
            }
        } catch {
            print("Error loading checklists, default list will be displayed")
        }
    }
    
    func saveChecklists(){
        guard let file = getListsFile() else {return}
        
        do {
            let data = try JSONEncoder().encode(checklists)
            try data.write(to: file)
        } catch {
            print("Error: failed to save checklists")
        }
        
    }
    
    // Add a new checklist
    func addChecklist(name: String) {
        let newChecklist = Checklist(name: name, tasks: [])
        checklists.append(newChecklist)
        saveChecklists()
    }
       
    // Rename option for user custom checklist
    func renameChecklist(id: UUID, newName: String) {
        if let index = checklists.firstIndex(where: { $0.id == id }) {
            checklists[index].name = newName
            saveChecklists()
        }
    }
       
    // Get tasks for a specific checklist
    func getTasks(for checklistId: UUID) -> [TaskItem] {
        if let checklist = checklists.first(where: { $0.id == checklistId }) {
            return checklist.tasks
        }
        return []
    }
       
    // Update tasks for a specific checklist
    func updateTasks(for checklistId: UUID, tasks: [TaskItem]) {
        if let index = checklists.firstIndex(where: { $0.id == checklistId }) {
            checklists[index].tasks = tasks
            saveTasks()
        }
    }
       
    // Remove a checklist, only if it's deletable
    func removeChecklist(id: UUID) {
        let checklist = checklists.first(where: { $0.id == id})
        if checklist!.canDelete {
            checklists.removeAll { $0.id == id }
            saveChecklists()
        }
    }


  //updates a new task to the specified checklist
    func addTask(to checklistId: UUID, title: String, isWellness: Bool = false){
        if let index = checklists.firstIndex(where: {$0.id == checklistId}){
            let newTask = TaskItem(title: title)
            checklists[index].tasks.append(newTask)
            saveChecklists()
        }
    }
    
//    //original addTask for default checklist
//    func addTask(title: String) {
//            let newTask = TaskItem(title: title)
//            taskList.tasks.append(newTask)
//            saveTasks()
//        }


  //marks task as completed once the user selects
    func markTastCompleted(task: TaskItem){
        if let ix = taskList.tasks.firstIndex(where: {$0.id == task.id}){
            taskList.tasks[ix].isCompleted.toggle()
            saveTasks()
        }
    }

  //removes task from default checklist
    func removeTask(task: TaskItem){
            taskList.tasks.removeAll{ $0.id == task.id }
            saveTasks()
    }
    
    //removes a task from a specific checklist
    func removeTask(from checklistId: UUID, task: TaskItem){
        if let index = checklists.firstIndex(where: { $0.id == checklistId}){
            checklists[index].tasks.removeAll { $0.id == task.id }
            saveTasks()
            saveChecklists()
        }
    }
}
