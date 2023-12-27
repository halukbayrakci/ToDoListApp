//
//  NoteViewController.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 28.12.2023.
//

import UIKit

final class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var checkButtonPressed: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    
    var viewModel = NoteViewModelViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
        
        noteTextViewUpdate()
        checkButtonPressedUpdate()
    }
    
    private func noteTextViewUpdate() {
        noteTextView.layer.cornerRadius = 20
        noteTextView.backgroundColor = .lightGray
        noteTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 5, right: 20)
    }
    
    private func checkButtonPressedUpdate() {
        checkButtonPressed.layer.cornerRadius = 40
        checkButtonPressed.backgroundColor = UIColor(named: "mainColor")
    }
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        if let note = noteTextView.text {
            viewModel.save(note: note)
        }
    }
    
}

extension NoteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        return true
    }
    
}
