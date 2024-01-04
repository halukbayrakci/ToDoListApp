//
//  NoteUpdateViewController.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 4.01.2024.
//

import UIKit

final class NoteUpdateViewController: UIViewController {
    @IBOutlet weak var noteUpdateTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    var notes: ToDo?
    var viewModel = NoteUpdateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteUpdateTextView.delegate = self
        
        if let n = notes {
            noteUpdateTextView.text = n.note
        }
        
        updateTextViewUpdate()
        updateButtonPressedUpdate()
    }
    private func updateTextViewUpdate() {
        noteUpdateTextView.layer.cornerRadius = 20
        noteUpdateTextView.backgroundColor = .lightGray
        noteUpdateTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 5, right: 20)
    }
    
    private func updateButtonPressedUpdate() {
        updateButton.layer.cornerRadius = 40
        updateButton.backgroundColor = UIColor(named: "mainColor")
    }
    

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        
        guard noteUpdateTextView.text.isEmpty == false else { return }
        
        if let note = noteUpdateTextView.text, let n = notes {
            viewModel.update(id: n.id!, note: note, creationDate: formattedDate)
        }
        
        print("update button ")
    }
    
}

//MARK: - UITextViewDelegate
extension NoteUpdateViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
}
