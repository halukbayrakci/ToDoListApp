//
//  ToDoNotesDaoRepository.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 29.12.2023.
//

import Foundation
import RxSwift

final class ToDoNotesDaoRepository {
    var notesList = BehaviorSubject<[ToDo]>(value: [ToDo]())
    
    let db: FMDatabase?
    
    init(){
        let bundleWay = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let targetPath = URL(fileURLWithPath: bundleWay).appendingPathComponent("toDo.sqlite")
        db = FMDatabase(path: targetPath.path)
        
        createColumn()
    }
    
    private func createColumn() {
        db?.open()
        do {
            try db!.executeUpdate("CREATE TABLE IF NOT EXISTS ToDo (id INTEGER PRIMARY KEY AUTOINCREMENT, note TEXT)", values: nil)
            let results = try db!.executeQuery("PRAGMA table_info(ToDo)", values: nil)
            var creationDateExists = false
            while results.next() {
                if let columnName = results.string(forColumn: "name"), columnName == "creationDate" {
                    creationDateExists = true
                    break
                }
            }
            
            if !creationDateExists {
                try db!.executeUpdate("ALTER TABLE ToDo ADD COLUMN creationDate TEXT", values: nil)
            }
        } catch {
            print("Veritabanı oluşturma veya güncelleme sırasında hata: \(error.localizedDescription)")
        }
        db?.close()
    }
    
    
    func save(note: String, creationDate: String){
        db?.open()
        
        do {
            try db!.executeUpdate("INSERT INTO ToDo (note, creationDate) VALUES (?, ?)", values: [note, creationDate])
            noteUpload()
        } catch {
            print("Not kaydedilirken hata oluştu: \(error.localizedDescription)")
        }
        
        db?.close()
    }
    
    func update(id: Int, note: String, creationDate: String){
        db?.open()
        
        do {
            try db!.executeUpdate("UPDATE ToDo SET note = ?, creationDate = ? WHERE id = ?", values: [note, creationDate, id])
            noteUpload()  // Güncelleme sonrası notları yeniden yükle
        } catch {
            print("Not güncellenirken hata oluştu: \(error.localizedDescription)")
        }
        
        db?.close()
        
    }
    
    func delete(id: Int){
        db?.open()
        
        do {
            try db!.executeUpdate("DELETE FROM ToDo WHERE id = ?", values: [id])
            noteUpload()
        } catch {
            print("Not silinirken hata oluştu: \(error.localizedDescription)")
        }
        
        db?.close()
    }
    
    func search(searchWord: String){
        db?.open()
        var noteList = [ToDo]()
        
        do {
            //            let rs = try db!.executeQuery("SELECT * FROM ToDo WHERE note LIKE '%\(searchWord)%'", values: nil)
            let rs = try db!.executeQuery("SELECT * FROM ToDo WHERE note LIKE ?", values: ["%\(searchWord)%"])
            
            while rs.next() {
                if let idString = rs.string(forColumn: "id"),
                   let id = Int(idString),
                   let note = rs.string(forColumn: "note"),
                   let creationDate = rs.string(forColumn: "creationDate") {
                    
                    let toDoItem = ToDo(id: id, note: note, creationDate: creationDate)
                    noteList.append(toDoItem)
                }
            }
            
            notesList.onNext(noteList) // Tetikleme
        } catch {
            print("Arama sırasında hata oluştu: \(error.localizedDescription)")
        }
        
        db?.close()
    }
    
    func noteUpload(){
        db?.open()
        var noteList = [ToDo]()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM ToDo", values: nil)
            while rs.next() {
                if let id = Int(rs.string(forColumn: "id") ?? "0"),
                   let note = rs.string(forColumn: "note"),
                   let creationDate = rs.string(forColumn: "creationDate") {
                    let toDoItem = ToDo(id: id, note: note, creationDate: creationDate)
                    noteList.append(toDoItem)
                }
            }
            
            notesList.onNext(noteList) // Tetikleme
        } catch {
            print("Notlar yüklenirken hata oluştu: \(error.localizedDescription)")
        }
        db?.close()
    }
    
}
