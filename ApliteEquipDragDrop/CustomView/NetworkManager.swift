//
//  NetworkManager.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 26/03/24.
//

import Foundation
import UIKit

let BaseUrl = "https://staging.eyeontask.com/eotServices/"




func callApi(completion:@escaping(Data?, Error?, Bool)->Void)  {
    var param = ["jobId" : "100"]

    var request = URLRequest(url: URL(string: "http://192.168.88.2:8435/eotServices/CommonController/getJobMap")!)
   // request.httpMethod = "GET"
    request.httpMethod = "POST"

    request.httpBody =  try? JSONSerialization.data(withJSONObject: param)
    
    URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
        do {
            let jsonDecoder = JSONDecoder()
            let responseModel = try jsonDecoder.decode(MapResponse.self, from: data!)
          //  print(responseModel)
            let returnData = String(data: data!, encoding: .utf8)
            print(returnData)
            completion(data, nil, true)

        } catch {
            print("JSON Serialization error")
        }
    }).resume()
}


//MARK:- MultipleImages upload created by Rohit -
func serverCommunicatorUplaodSignatureAndAttachment(stringUrl:String, method:String,parameters:[String:Any]?,imageSig:[ImageModel]?,imageAtchmnt:[ImageModel]?, signaturePath:String,atchmntPath:String, completion: @escaping(Data?, Error?, Bool)->Void) {
    // boundary setup
    let boundary = "----------V2ymHFg03ehbqgZCaKO6jy"
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    guard let url = URL(string: "http://192.168.88.2:8435/eotServices/CommonController/addUpdateJobMap") else { return }
    let origne = url.host
    var request = URLRequest(url: url)
    request.httpMethod = method
   // request.addValue(authenticationToken ?? "", forHTTPHeaderField: "Token")
    request.addValue("https://\(origne ?? "")", forHTTPHeaderField: "Origin")
    
  /*  if let isAutoTimeZone = getDefaultSettings()?.isAutoTimeZone{
        if isAutoTimeZone == "0"{
            request.setValue(TimeZone.current.identifier, forHTTPHeaderField: "User-Time-Zone")
        }else{
            let loginUsrTz = getDefaultSettings()?.loginUsrTz
            request.setValue(loginUsrTz, forHTTPHeaderField: "User-Time-Zone")

        }
    }*/
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
// parameter encoding
    var data = Data()
    if parameters != nil{
        for(key, value) in parameters!{
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            if  key == "mapItemsXXX" || key == "answerArray" || key == "isMarkDoneWithJtId" || key == "signQueIdArray" {
                do {
                    let ansDatatry = try JSONSerialization.data(withJSONObject: value , options: JSONSerialization.WritingOptions())
                    data.append(ansDatatry)
                    data.append(Data("\r\n".utf8))
                } catch let error {
                    print("error while creating post request -> \(error.localizedDescription)")
                }
            }else{
                data.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }

    
    if let imageArray = imageSig {
        if imageArray.count > 0 {
            for (index,image) in imageArray.enumerated() {
                var imageData : Data?
                imageData = image.img!.jpegData(compressionQuality: 0.5)
                let imageFileName = "signature_\(index).png"
                
                if (imageData != nil) {
                   
                               data.append("--\(boundary)\r\n".data(using: .utf8)!)
                                data.append("Content-Disposition: form-data; name=\"\(signaturePath)\"; filename=\"\(imageFileName)\"\r\n".data(using: .utf8)!)
                                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                               data.append(imageData!)
                                data.append(Data("\r\n".utf8))
                }
            }
        }
    }
    
    data.append("--\(boundary)--\r\n".data(using: .utf8)!)
    session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
        if let checkResponse = response as? HTTPURLResponse{
            if checkResponse.statusCode == 200 {
               // printLog(String(data: data!, encoding: .utf8))
                guard let data = data, let jes1 = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) else {
                    completion(nil, error, false)
                    return
                }
               // printLog(String(data: data, encoding: .utf8))
                completion(data, nil, true)
            } else {
                guard let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    completion(nil, error, false)
                    return
                }
                completion(data, nil, false)
            }
        } else {
            guard let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: []) else {
                completion(nil, error, false)
//                if let checkResponse = response as? HTTPURLResponse{
//                }
                return
            }
            completion(data, nil, false)
        }
    }).resume()
}
struct ImageModel {
    var img: UIImage?
    var id: String?
    var frmId:String?
}

func convertIntoJSONStringForRecur(arrayObject: [Any]) -> String? {
     
     do {
         let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
         if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
             return jsonString as String
         }
         
     } catch let error as NSError {
       //  print("Array convertIntoJSON - \(error.description)")
     }
     return nil
 }

extension Dictionary {
    var toString: String? {
            let dictionary = self
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            return jsonString
    }
    
    var toData: Data? {
            let dictionary = self
            let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
    }
    
    
    
}
