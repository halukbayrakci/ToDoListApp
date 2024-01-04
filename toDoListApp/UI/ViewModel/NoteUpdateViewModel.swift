//
//  NoteUpdateViewModel.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 4.01.2024.
//

import Foundation

final class NoteUpdateViewModel {
    var repo = ToDoNotesDaoRepository()
    
    func update(id: Int, note: String, creationDate: String) {
        repo.update(id: id, note: note, creationDate: creationDate)
    }
}
