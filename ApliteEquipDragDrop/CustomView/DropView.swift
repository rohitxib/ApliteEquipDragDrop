//
//  DropView.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 17/04/23.
//

import UIKit
import Foundation

public class DropView: UIView {

    @IBOutlet weak var lblMain: UILabel!
  //  @IBOutlet weak var tblView: UITableView!
    @IBOutlet var viewContainer: UIView!
    public   var arrayData = Array(arrayLiteral: String())
    var itemID = ""
    
   
   

    
          
    
 public   var dataCalbacCancle :(DropView)->() = {_ in }
    public   var dataCalbacTap :(DropView)->() = {_ in }

    override init(frame: CGRect) {
           super.init(frame: frame)
        self.initSubview()
       }

       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           self.initSubview()
       }
    private   func initSubview()  {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
      nib.instantiate(withOwner: self ,options: nil)
       // viewContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewContainer)
       
       // self.addConstrants()
        viewContainer.fixInView(self)
        //
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)

        self.isUserInteractionEnabled = true

       }
    
    @IBAction func btnCancleAction(_ sender: Any) {
        dataCalbacCancle(self)
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dataCalbacTap(self)    }
   
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
