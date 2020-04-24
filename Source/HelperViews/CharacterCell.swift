//
//  TableViewCell.swift
//  Roll Companion (Swift)
//
//  Created by Jared Heddinger on 2/15/20.
//  Copyright © 2020 Jared Heddinger. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    
    var character: Character1? {
        didSet {
            guard let character = character else { return }
            
            nameLabel.text = character.name
            levelLabel.text = "Level: " + ((character.toClasses?.reduce(0, { $0 + ($1 as! Class1).level }))?.description)!
            classLabel.text = character.toClasses?.reduce("", {$0 + (($1 as! Class1).name! + ": " + ($1 as! Class1).level.description)})
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCharacter() -> Character1 {
        return self.character!
    }

}
