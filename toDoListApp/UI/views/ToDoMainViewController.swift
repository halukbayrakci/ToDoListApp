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
        
        _ = viewModel.notesList.subscribe(onNext: { list in
            self.notesList = list
            self.toDoMainTableView.reloadData()
        })
     
        tableViewUpdate()
        searchBarUpdate()
        addButtonUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.noteUpload()
        toDoMainTableView.reloadData()
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
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
    }
    
}

extension ToDoMainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchWord: searchText)
    }
}


extension ToDoMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        let noteList = notesList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ToDoMainTableViewCell else { fatalError()}
        
        cell.toDoView.layer.cornerRadius = 25
        cell.toDoView.backgroundColor = UIColor(named: "grayColor")
        
        cell.toDoTitleLabel.text = noteList.note
        cell.toDoTitleLabel.textColor = .white
        cell.toDoSubtitleLabel.text = formattedDate
        cell.toDoSubtitleLabel.textColor = .white
        
        cell.backgroundColor = UIColor(named: "mainColor")
        
        // Seçilen öğenin indeksi seçilenItems set'inde ise checkmark aksesuarını göster
        if selectedItems.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let noteList = notesList[indexPath.row].note
        let textLength = noteList.count
        
        switch textLength {
        case 0..<20:
            return 100
        case 20..<30:
            return 120
        case 30..<75:
            return 150
        case 75..<90:
            return 170
        case 90..<150:
            return 200
        default:
            return 300
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedItems.contains(indexPath.row) {
            selectedItems.remove(indexPath.row)
        } else {
            selectedItems.insert(indexPath.row)
        }
        
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteSwipeAction = UIContextualAction(style: .destructive, title: "DELETE") {_,_,_ in 
            let note = self.notesList[indexPath.row]
            
            let alert = UIAlertController(title: "Warning !", message: "\(note.note) delete ? ", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                self.viewModel.delete(id: note.id)
            }
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [deleteSwipeAction])
    }
    
}


