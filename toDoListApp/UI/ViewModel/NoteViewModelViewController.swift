//
//  NoteViewModelViewController.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 29.12.2023.
//

import Foundation

final class NoteViewModelViewController {
    var repo = ToDoNotesDaoRepository()
    
    func save(note: String, creationDate: String ){
        repo.save(note: note, creationDate: creationDate)
    }
}
