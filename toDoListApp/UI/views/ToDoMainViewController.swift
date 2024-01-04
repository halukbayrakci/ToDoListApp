//
//  ViewController.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 27.12.2023.
//

import UIKit

final class ToDoMainViewController: UIViewController {
    
    @IBOutlet weak var toDoSearchBar: UISearchBar!
    @IBOutlet weak var toDoMainTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var notesList = [ToDo]()
    var viewModel = ToDoMainViewModelViewController()
    var selectedItems = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "mainColor")
        
        _ = viewModel.notesList.subscribe(onNext: { [weak self] list in
            DispatchQueue.main.async {
                self?.notesList = list
                self?.toDoMainTableView.reloadData()
            }
        })
        
        tableViewUpdate()
        searchBarUpdate()
        addButtonUpdate()
        loadSelections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.noteUpload()
        DispatchQueue.main.async {
            self.toDoMainTableView.reloadData()
        }
    }
    
    private func addButtonUpdate() {
        addButton.layer.cornerRadius = 40
    }
    
    private func searchBarUpdate() {
        toDoSearchBar.searchTextField.backgroundColor = UIColor(named: "grayColor")
        toDoSearchBar.tintColor = .white
        toDoSearchBar.searchTextField.textColor = .white
        toDoSearchBar.searchTextField.leftView?.tintColor = .white
        toDoSearchBar.barTintColor = UIColor(named: "mainColor")
        toDoSearchBar.setPlaceholderColor(.white)
        toDoSearchBar.removeBorder()
        toDoSearchBar.setClearButtonColor(.white)
        
    }
    
    private func tableViewUpdate() {
        toDoMainTableView.backgroundColor = UIColor(named: "mainColor")
        toDoMainTableView.separatorColor = UIColor(named: "mainColor")
    }
    
    private func saveSelections() {
        UserDefaults.standard.set(Array(selectedItems), forKey: "selectedItems")
    }
    
    private func loadSelections() {
        if let savedSelections = UserDefaults.standard.array(forKey: "selectedItems") as? [Int] {
            selectedItems = Set(savedSelections)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdate" {
            if let note = sender as? ToDo {
                let destinationVC = segue.destination as! NoteUpdateViewController
                destinationVC.notes = note
            }
        }
    }
    
    @IBAction func unwindToToDoMainViewController(unwindSegue: UIStoryboardSegue) {
        viewModel.noteUpload()
        DispatchQueue.main.async {
            self.toDoMainTableView.reloadData()
        }
    }
    
    
}

//MARK: - UISearchBarDelegate
extension ToDoMainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchWord: searchText)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ToDoMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let noteList = notesList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ToDoMainTableViewCell else { fatalError()}
        
        cell.toDoView.layer.cornerRadius = 25
        cell.toDoView.backgroundColor = UIColor(named: "grayColor")
        
        cell.toDoTitleLabel.text = noteList.note
        cell.toDoTitleLabel.textColor = .white
        cell.toDoSubtitleLabel.text = noteList.creationDate
        cell.toDoSubtitleLabel.textColor = .white
        
        cell.backgroundColor = UIColor(named: "mainColor")
        cell.accessoryType = selectedItems.contains(indexPath.row) ? .checkmark : .none
        
        saveSelections()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteList = notesList[indexPath.row]
        
        if selectedItems.contains(indexPath.row) {
            selectedItems.remove(indexPath.row)
        } else {
            selectedItems.insert(indexPath.row)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = self.notesList[indexPath.row]
        
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "DELETE") {_,_,_ in

            let alert = UIAlertController(title: "Warning !", message: "\(note.note!) delete ? ", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.viewModel.delete(id: note.id!)
            }
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let note = self.notesList[indexPath.row]
        
        let editSwipeAction = UIContextualAction(style: .normal, title: "EDIT") { _, _, _ in
            
            self.performSegue(withIdentifier: "toUpdate", sender: note)
        }
        editSwipeAction.backgroundColor = .lightGray
        return UISwipeActionsConfiguration(actions: [editSwipeAction])
    }
    
    
}


