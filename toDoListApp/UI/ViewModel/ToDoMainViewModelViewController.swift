//
//  ToDoMainViewModelViewController.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 29.12.2023.
//

import Foundation
import RxSwift

final class ToDoMainViewModelViewController {
    var repo = ToDoNotesDaoRepository()
    var notesList = BehaviorSubject<[ToDo]>(value: [ToDo]())
    
    init() {
        dbCopy()
        notesList = repo.notesList
        noteUpload()
    }
    
    func delete(id:Int){
        repo.delete(id: id)
    }
    
    func search(searchWord:String){
        repo.search(searchWord: searchWord)
    }
    
    func noteUpload(){
        repo.noteUpload()
    }
    
    private func dbCopy(){
        let bundleWay = Bundle.main.path(forResource: "toDo", ofType: ".sqlite")
        let targetPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let placeToCopy = URL(fileURLWithPath: targetPath).appendingPathComponent("toDo.sqlite")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: placeToCopy.path){
            print("Veritabanı zaten var")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleWay!, toPath: placeToCopy.path)
            }catch{}
        }
    }
}
