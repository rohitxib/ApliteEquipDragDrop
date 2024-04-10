//
//  ViewController33.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 26/03/24.
//

import UIKit

class ViewController33: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

     /*   callApi(){ response, error, succes in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(MapResponse.self, from: response!)
                print(responseModel)
                if responseModel.success == true{
                    guard let datares = responseModel.data else { return  }
                    guard let datafirst = datares.first else { return  }
                    guard let mapJason = datafirst.map_jsonData else { return  }
                    guard let mapItemsAll = mapJason.mapItems else { return  }
                    let mapItemArr = self.getAvailAndConsumedItem(mapItemArr: mapItemsAll)
                    let avalitem = mapItemArr.availItemArr
                    let consumeditem = mapItemArr.consumedItemArr

                }
                
                
            } catch {
                print("JSON Serialization error")
            }
        }*/
    }
    
    func getAvailAndConsumedItem(mapItemArr : [MapItems]) -> (availItemArr : [MapItems],consumedItemArr : [MapItems]) {
        var availItems = [MapItems]()
        var consumedItems = [MapItems]()
        for item in mapItemArr {
            if item.availability == "true" {
                availItems.append(item)
            }else if item.availability == "fals"{
                consumedItems.append(item)
            }
        }
        
        return (availItems,consumedItems)
    }
    
}
