//
//  TaskModel.swift
//  Elephant
//
//  Created by Pruneda Turcios, Gabriela (Gabby) on 4/5/25.
//

import Foundation

// Represents a TaskItem object for each
struct TaskItem: Identifiable, Codable{
    let id: UUID //unique task identifier
    var title: String // title/description of the task
    var isCompleted: Bool // boolean for task completion
    var isWellness: Bool // whether this is a wellness task (only wellness task gives tokens)

    //default state for task completion set to false
    //Generates a new unique ID for each task
    init(title: String, isCompleted: Bool = false, isWellness: Bool = false){
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.isWellness = isWellness
    }
}

//stores list of taskItem objects
struct TaskList: Codable{
    var tasks: [TaskItem]
}
