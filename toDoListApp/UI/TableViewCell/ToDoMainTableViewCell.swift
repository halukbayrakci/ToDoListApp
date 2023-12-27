//
//  toDoMainTableViewCell.swift
//  toDoListApp
//
//  Created by HALUK BAYRAKCI on 27.12.2023.
//

import UIKit

final class ToDoMainTableViewCell: UITableViewCell {
    @IBOutlet weak var toDoView: UIView!
    @IBOutlet weak var toDoTitleLabel: UILabel!
    @IBOutlet weak var toDoSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
