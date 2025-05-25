//
//  TaskListStorage.swift
//  Elephant: A Wellness Trunk
//
//  Created by Pruneda Turcios, Gabriela (Gabby) on 4/6/25.
//
import SwiftUI
import Foundation

//struct for individual checklist initialization
struct Checklist: Identifiable, Codable {
    var id = UUID()
    var name: String
    var tasks: [TaskItem]
}

//TaskListStorage stores tasks objects to file TaskLists.json
class TaskListStorage: ObservableObject{
    private let tasksFilename = "TaskLists.json"
    private let checklistsFilename = "Checklists.json"
    
    @AppStorage("lastTasklistUpdate") var lastTasklistUpdate: Double = 0.0
    
    @Published var curChecklistId: UUID? = nil
    var curChecklist: Checklist?
    @Published var taskList = TaskList(tasks: []){ //saves current task list
        didSet{
            saveTasks()//updates tasks
        }
    }
    
    @Published var checklists: [Checklist] = [] {
        didSet {
            saveChecklists()
            //SharedDataManager.shared.saveChecklists(checklists)
        }
    }
    
    func validateCurrentChecklist() {
        if !checklists.contains(where: { $0.id == curChecklistId }) {
            curChecklistId = checklists.first?.id
        }
    }
    
    func updateTaskList() {
        let today = Date.now
        let lastUpdateDate = NSDate(timeIntervalSince1970: lastTasklistUpdate)
        // if not same day, delete all tasks that are completed
        if !Calendar.current.isDate(today, inSameDayAs: lastUpdateDate as Date) {
            lastTasklistUpdate = today.timeIntervalSince1970
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
        loadTasks() //loads tasks for user view
        loadChecklists() //loads all currently existing checklists
        
        // created default grinnell wellness checklist if none currently exists
        if checklists.isEmpty {
            let firstChecklist = Checklist(name: "Fun activities at Grinnell!", tasks: [])
            checklists.append(firstChecklist)
            curChecklistId = firstChecklist.id
            addTask(to: curChecklistId!, title: "Get a drink and snacks at DSA suite (JRC 3rd)")
            addTask(to: curChecklistId!, title: "Get coffee at Saints rest")
            addTask(to: curChecklistId!, title: "Get ice cream at Dari Barn")
            addTask(to: curChecklistId!, title: "Chill at the hammocks")
            addTask(to: curChecklistId!, title: "Play a game (pool/foosball/ping pong) at game room")
            curChecklistId = firstChecklist.id
            curChecklist = firstChecklist
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
       
    // Remove a checklist
    func removeChecklist(id: UUID) {
        checklists.removeAll { $0.id == id }
        saveChecklists()
    }


  //updates a new task to the specified checklist
    func addTask(to checklistId: UUID, title: String){
        if let index = checklists.firstIndex(where: {$0.id == checklistId}){
            let newTask = TaskItem(title: title)
            checklists[index].tasks.append(newTask)
            saveChecklists()
        }
    }
    
    //original addTask for default checklist
    func addTask(title: String) {
            let newTask = TaskItem(title: title)
            taskList.tasks.append(newTask)
            saveTasks()
        }


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
