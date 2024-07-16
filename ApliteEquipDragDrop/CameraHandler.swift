//
//  CameraHandler.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 12/04/24.
//

//
//  CameraHandler.swift
//  EyeOnTask
//
//  Created by Aplite on 12/12/23.
//  Copyright © 2023 Hemant. All rights reserved.
//

import Foundation
import UIKit
import PhotosUI
import MobileCoreServices


class CameraHandler: NSObject{
    static let shared = CameraHandler()
    
    fileprivate var currentVC: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: (([UIImage]) -> Void)?
    var documentPickedUrlBlock: ((URL) -> Void)?
    
    func checCameraPermession(vc: UIViewController , completion : @escaping ( Bool) ->()) {
        currentVC = vc
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    completion(true)
                } else {
                    self.shoewSetingAllert(vc: vc)
                }
            }
        }
    }
    
    func camera(){
        DispatchQueue.main.async {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            DispatchQueue.main.async{
                self.currentVC.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    }
    
    func photoLibrary(){
        if #available(iOS 14.0, *) {
            DispatchQueue.main.async{
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 10 // Selection limit. Set to 0 for unlimited.
            configuration.filter = .images // he types of media that can be get.
            // configuration.filter = .any([.videos,livePhotos]) // Multiple types of media
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
           // DispatchQueue.main.async{
                self.currentVC.present(picker, animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func document()   {
            let kUTTypeDOC = "com.microsoft.word.doc" // for Doc file
            let kUTTypeDOCX = "org.openxmlformats.wordprocessingml.document" // for Docx file
            let kUTTypeXls = "com.microsoft.excel.xls"
            let kUTTypeXlsx = "org.openxmlformats.spreadsheetml.sheet"
            
            //'jpg','png','jpeg','pdf','doc','docx','xlsx','csv','xls'
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypePDF),String(kUTTypeCommaSeparatedText),kUTTypeXls,kUTTypeXlsx,kUTTypeDOCX,kUTTypeDOC], in: .import)
            documentPicker.delegate = self
           // APP_Delegate.showBackButtonTextForFileMan()
            self.currentVC.present(documentPicker, animated: true, completion: nil)
    }
    
    func showActionSheet(vc: UIViewController,addDocumentPicker: Bool,addCancel: Bool) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //adding camera
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
           // self.camera()
            let source = UIImagePickerController.SourceType.camera
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                self.camera()
            } else {
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    guard let self = self else { return }
                    if granted {
                        self.camera()
                    } else {
                        self.shoewSetingAllert(vc: vc)
                    }
                }
            }
        }))
        
        // adding photo library
        actionSheet.addAction(UIAlertAction(title: "gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
           // self.photoLibrary()
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == PHAuthorizationStatus.denied || status == PHAuthorizationStatus.notDetermined) {
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if (newStatus == PHAuthorizationStatus.authorized) {
                        self.photoLibrary()
                    } else {
                        self.shoewSetingAllert(vc: vc)
                    }
                })
            } else if status == PHAuthorizationStatus.authorized {
                self.photoLibrary()
            }
        }))
        
        //adding document picker
        if addDocumentPicker == true{
            actionSheet.addAction(UIAlertAction(title: "document", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.document()
            }))
        }
        if addCancel == true{
             actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        }
            vc.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func shoewSetingAllert(vc:UIViewController) {
        let myAlert = UIAlertController(title: "EyeOnTask Would Like to Access Your Photos", message: "Eye on task access Photo library to allow you to attach documents to the work orders.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        let settingAction = UIAlertAction(title: "settings", style: .default, handler: { action in
            guard   let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingsUrl) else {  return }
             UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        })
        
        myAlert.addAction(settingAction)
        myAlert.addAction(cancelAction)
        DispatchQueue.main.async{
            vc.present(myAlert, animated:true, completion:nil)
        }
    }
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
                   return
        }
        self.imagePickedBlock?([image])
        currentVC.dismiss(animated: true, completion: nil)
    }
}

extension CameraHandler: PHPickerViewControllerDelegate  {
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        currentVC.dismiss(animated: true, completion: nil)
      
        if results.count > 0 {
            var selectedImages = [UIImage]()
            for itemResult in results{
                let tempItemProvider = itemResult.itemProvider
                if tempItemProvider.canLoadObject(ofClass: UIImage.self) {
                    tempItemProvider.loadObject(ofClass: UIImage.self) { [weak self]  image, error in
                        if let tempImage = image as? UIImage {
                            selectedImages.append(tempImage)
                            if selectedImages.count == results.count{
                                self?.imagePickedBlock?(selectedImages)
                            }
                        }
                            }
                        }
                    }
                }
            }
          
        }
    
    
    
extension CameraHandler: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
       // APP_Delegate.hideBackButtonText()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.documentPickedUrlBlock?(url)
    }
    
}
