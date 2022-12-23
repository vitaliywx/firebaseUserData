//
//  Task.swift
//  FireBaseUserData
//
//  Created by Vitalii Homoniuk on 22.12.2022.
//

import Foundation

class Task: Identifiable, Codable {
    
    var taskId: String = ""
    var text: String
    
    init(text: String, taskId: String) {
        self.text = text
        self.taskId = taskId
    }
}
