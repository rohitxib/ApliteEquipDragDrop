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
      //  self.rotateToLandsScapeDevice()

        self.imagePicker.delegate = self
       //7876878
      let safeAria =  UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets
        print(safeAria)
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        print("")
    }
    override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
      //  self.rotateToPotraitScapeDevice()
      }
    func rotateToLandsScapeDevice(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .landscapeLeft
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    func rotateToPotraitScapeDevice(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }

    @IBAction func btnActionTakePicture(_ sender: Any) {
        takePicture()
    }
    @IBAction func btnActionGoMap(_ sender: Any) {
        let mapVC = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
      //  mapVC.dimention = img.frame.size
    //    mapVC.imageMap = img.image ?? UIImage(named: "3dRoom2")!
        let img2 =  img.image ?? UIImage(named: "3dRoom2")!
        mapVC.imageMap =  img2.fixedOrientation()!
        self.navigationController!.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func btnActionDownload_Map(_ sender: Any) {

        let mapVC = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    
        let img2 = UIImage(named: "3dRoom2")!
        mapVC.imageMap =  img2.fixedOrientation()!
        mapVC.download_map = true
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

extension UIImage {
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}


