//
//  Task.swift
//  FireBaseUserData
//
//  Created by Vitalii Homoniuk on 22.12.2022.
//

import Foundation

class Task: Identifiable, Codable {
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
