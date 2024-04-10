//
//  TableViewCellMap.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 17/04/23.
//

import UIKit

class TableViewCellMap: UITableViewCell {
    @IBOutlet weak var lblEquipment: UILabel!
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var viewBackgraund: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackgraund.layer.borderWidth = 1
        viewBackgraund.layer.cornerRadius = 5

        viewBackgraund.layer.borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        viewBackgraund.clipsToBounds = true


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnActionChek(_ sender: Any) {
        if btnCheck.isSelected{
            btnCheck.isSelected = false
            btnCheck.setImage(UIImage(named: "check"), for: .normal)
                }else{
                    btnCheck.isSelected = true
                    btnCheck.setImage(UIImage(named: "uncheck"), for: .normal)
                }
    }
   
}
