//
//  ViewControllerSecond.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 21/04/23.
//

import UIKit

class ViewControllerSecond: UIViewController {

    @IBOutlet weak var btnGOMap: UIButton!
    @IBOutlet weak var img: UIImageView!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
       
    }
    @IBAction func btnActionTakePicture(_ sender: Any) {
        takePicture()
    }
    @IBAction func btnActionGoMap(_ sender: Any) {
        let mapVC = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
      //  mapVC.dimention = img.frame.size
        mapVC.imageMap = img.image ?? UIImage(named: "3dRoom2")!
        self.navigationController!.pushViewController(mapVC, animated: true)
    }
}
extension ViewControllerSecond:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func takePicture()  {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "cancel" , style: .cancel) { _ in
        }
        let camera = UIAlertAction(title: "camera", style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: {
                })
            }
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.sourceType = .photoLibrary;
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: {
                })
            }
        }
        actionSheet.addAction(cancelActionButton)
        actionSheet.addAction(gallery)
        actionSheet.addAction(camera)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
      //  self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        img.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo image: UIImage, editingInfo: [String : AnyObject]?) {
        img.contentMode = .scaleAspectFill
        img.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
