//
//  ViewControllerFirst.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 21/04/23.
//

import UIKit

class ViewControllerFirst: UIViewController {
    @IBOutlet weak var btnPicture: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnActionPicture(_ sender: Any) {
        let secondVC = self.storyboard!.instantiateViewController(withIdentifier: "ViewControllerSecond") as! ViewControllerSecond
        self.navigationController!.pushViewController(secondVC, animated: true)
        
    }
    

}
