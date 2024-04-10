//
//  ViewController.swift
//  ApliteEquipDragDrop
//
//  Created by Aplite on 17/04/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var tblWidthConstrents: NSLayoutConstraint!
    @IBOutlet weak var tblHeightConstrents: NSLayoutConstraint!
    @IBOutlet weak var tblViewDrag: UITableView!
    @IBOutlet weak var tblViewDrop: UITableView!
    @IBOutlet weak var viewInSideTable: UIView!
    
    var originalSizeMapImage = CGSize() // will be calculated from picked image Or geted from server and not chenge
    var canvasSizeDefalt = CGSize(width: 0, height: 500)
    var aspectRatio = Float()
    var magifiedPercent = 0
    

    var imageMap = UIImage()
    
    var viewArray:[DropView] = []
    
    var availableItems = [MapItems]()
    var consumedItems = [MapItems]()
    var roomImage = UIImageView()
// helper
  
   var initialMgnifiedRatio = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDetail.isHidden = true
        
        self.originalSizeMapImage = imageMap.size
       
        
        let reduceAspectRatio = canvasSizeDefalt.height/originalSizeMapImage.height
        //reducing to defalt size of canvas that is currentaly heigt = 500
       let  hight_imgMapAfterDownSacle = originalSizeMapImage.height*reduceAspectRatio
      let  width_imgMapAfterDownSacle = originalSizeMapImage.width*reduceAspectRatio

        canvasSizeDefalt = CGSize(width: width_imgMapAfterDownSacle, height: hight_imgMapAfterDownSacle)
        
        self.tblViewDrop.frame.size = canvasSizeDefalt
          self.viewInSideTable.frame.size = self.tblViewDrop.frame.size

      //  self.tblHeightConstrents.constant = 500
     //   self.tblWidthConstrents.constant = 417
        self.tblHeightConstrents.constant = CGFloat(canvasSizeDefalt.height - 500)// 500
        self.tblWidthConstrents.constant = CGFloat(canvasSizeDefalt.width - 383)//417
       // let roomImage = UIImageView(image: UIImage(named: "3droom"))
      //  let roomImage = UIImageView()
        roomImage.image = imageMap
        roomImage.frame = viewInSideTable.frame
        roomImage.contentMode = .scaleAspectFit//.scaleToFill
        viewInSideTable.addSubview(roomImage)
        print("tblViewDrop Size == \(tblViewDrop.frame.size)")
        print("viewInSideTable Size == \(viewInSideTable.frame.size)")
        print("roomImage Size == \(roomImage.frame.size)")

        registerTableViewCells()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.renderEquipmentOnMAP()
      //  fillDataModels()
       self.downloadmapData()
    }
    @IBAction func btnActionOpenTable(_ sender: Any) {
        if tblViewDrag.isHidden == false {
            tblViewDrag.isHidden = true
        }else{
            tblViewDrag.isHidden = false
        }
    }
    
    @IBAction func btnActionClose(_ sender: Any) {
        viewDetail.isHidden = true
    }
    //scaling action
    @IBAction func btnActionScapleUp(_ sender: Any) {
        if self.initialMgnifiedRatio < 100{
            multiplyby(ratio: 1.1)
            self.initialMgnifiedRatio += 10
        }
    }
    @IBAction func btnActionScapleDown(_ sender: Any) {
        if self.initialMgnifiedRatio > 0{
            multiplyby(ratio: 0.9090)
            self.initialMgnifiedRatio -= 10
        }
    }
    
    
    func multiplyby(ratio:Float) {
        
        
        canvasSizeDefalt = CGSize(width: canvasSizeDefalt.width*CGFloat(ratio), height: canvasSizeDefalt.height*CGFloat(ratio))
        self.tblHeightConstrents.constant = CGFloat(canvasSizeDefalt.height - 500)// 500
        self.tblWidthConstrents.constant = CGFloat(canvasSizeDefalt.width - 383)//417
        
        self.tblViewDrop.frame.size = canvasSizeDefalt
        self.viewInSideTable.frame.size = self.tblViewDrop.frame.size
        
        
        roomImage.frame.size = viewInSideTable.frame.size
        
        // roomImage.frame.origin.x = 50
        // roomImage.frame.origin.y = 50
        
     /*   for itemTem in self.consumedItems {
            itemTem.coordinateX = itemTem.coordinateX! * ratio
            itemTem.coordinateY =  itemTem.coordinateY! * ratio
        }
        
        for itemVw in self.viewArray{
            let itemNewXpos = (itemVw.frame.origin.x + 50)*CGFloat(ratio)
            itemVw.frame.origin.x = itemNewXpos - 50
            itemVw.frame.origin.y = itemVw.frame.origin.y*CGFloat(ratio)
            
    }*/
        for itemVw in self.viewArray{
            let itemNewXpos = (itemVw.frame.origin.x + 50)*CGFloat(ratio)
            itemVw.frame.origin.x = itemNewXpos - 50
            itemVw.frame.origin.y = itemVw.frame.origin.y*CGFloat(ratio)
            
            if   let itemIndx =  self.consumedItems.firstIndex(where: {$0.itemID == itemVw.itemID}){
                self.consumedItems[itemIndx].coordinateX =  Float(itemVw.frame.origin.x)
                self.consumedItems[itemIndx].coordinateY = Float(itemVw.frame.origin.y)
            }
        }

    }
    // sending data
    @IBAction func btnActionSaveMapToServer(_ sender: Any) {
        
        var consItm = [[String:Any]]()
        for itemData in self.consumedItems {
            var paramItem = [String:Any]()
            paramItem["coordinateX"] =  itemData.coordinateX
            paramItem["coordinateY"] = itemData.coordinateY
            paramItem["name"] = itemData.name
            paramItem["description"] = itemData.description
            paramItem["photoOfItem"] = itemData.photoOfItem
            paramItem["itemID"] = itemData.itemID
            paramItem["availability"] = itemData.availability
            consItm.append(paramItem)
        }
        
        
        var paramDic = [String:Any]()
        paramDic["jobId"] = "100"
        paramDic["mapId"] = "25"

        paramDic["mapLength"] = canvasSizeDefalt.height //"600"
        paramDic["mapWidth"] = canvasSizeDefalt.width//"600"
        paramDic["title"] = "Domestic map"
        paramDic["mapItems"] = convertIntoJSONStringForRecur(arrayObject: consItm)!//consItm
        paramDic["mapImageUrl"] = "mapImageUrl"

        
        
      
        var imageData = ImageModel()
        imageData.img = self.imageMap
        imageData.id = "myFirstImage"

        
        serverCommunicatorUplaodSignatureAndAttachment(stringUrl: "abc", method: "POST", parameters: paramDic, imageSig: [imageData], imageAtchmnt: [imageData], signaturePath: "mapImageUrl", atchmntPath: "do") { response, error, succes in
            let returnData = String(data: response!, encoding: .utf8)
            print(returnData)
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
          //  arrSignature.removeAll()
          //  arrAttacment.removeAll()
           // APP_Delegate.mainArr.removeAll()
           // self.excutApiResult(response: response, success: succes)
        }

    }
    
}
// add pan gesture to droped view
extension ViewController {
    func mooveViewss()  {
        print("no of view =\(viewArray.count)")
        for vie in viewArray {
            print(vie.layer.frame.size.height)
           // let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture))
            let panGesture = CustomPanGestureRecognizer(target: self, action: #selector(self.panGesture))
            panGesture.ourCustomValue = vie.itemID
            vie.isUserInteractionEnabled = true
            vie.isUserInteractionEnabled = true
            vie.isMultipleTouchEnabled = true
            vie.addGestureRecognizer(panGesture)
        }
    }
    @objc func panGesture(sender: CustomPanGestureRecognizer){
        let point = sender.location(in: self.viewInSideTable)
        let panGestureView = sender.view
        panGestureView?.center = point
        print(point)
        
        let dragedItemID = sender.ourCustomValue
        print(dragedItemID)
      let dragItemIndex =  consumedItems.firstIndex(where: { $0.itemID == dragedItemID })
        consumedItems[dragItemIndex!].coordinateX = Float(point.x) - 25
        consumedItems[dragItemIndex!].coordinateY = Float(point.y) - 25

        if (sender.view!.frame.intersects(viewInSideTable.frame)){
            panGestureView?.center = point
        }else{
            panGestureView?.center = viewInSideTable.center
        }
    }
}
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  availableItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                   let cell = tblViewDrag.dequeueReusableCell(withIdentifier: "TableViewCellMap", for: indexPath) as! TableViewCellMap
        cell.lblEquipment?.text = availableItems[indexPath.row].name
               return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("sd")
    }
}
extension ViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("TableitemsForBeginning")
        let dragItem = self.dragItem(forPhotoAt: indexPath)
               return [dragItem]
    }
    // Helper method
       private func dragItem(forPhotoAt indexPath: IndexPath) -> UIDragItem {
           self.tblViewDrag.isHidden = true
           let string = "\(indexPath.row)"
           let itemProvider = NSItemProvider(object: string as NSItemProviderWriting)// it can also  string.data(using: .utf8)
           let dragItem = UIDragItem(itemProvider: itemProvider)
           return dragItem
       }
}
extension ViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        var senderIndexPathRow = 0
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let string = items as? [String] else { return }
            for (index, value) in string.enumerated() {
                senderIndexPathRow = Int(value)!
            }
        }
        // setting custom view
        let dropPoint = coordinator.session.location(in: self.viewInSideTable)
        print("location =======\(dropPoint)")// width: 90, height: 80)
        let reusebleview = DropView(frame: CGRect(x:dropPoint.x , y:dropPoint.y, width: 50, height: 50))
        reusebleview.lblMain.text = availableItems[senderIndexPathRow].name
        reusebleview.itemID = availableItems[senderIndexPathRow].itemID ?? "000000"

        
        reusebleview.dataCalbacCancle = { name  in
            print("Hey there, \(name).")
            if let index = self.viewArray.firstIndex(of: name) {
                self.viewArray[index].removeFromSuperview()
                let canceledItemID =  self.viewArray[index].itemID
                //let canceledItem = self.consumedItems[canceledItemID]
                let canceledItem = self.consumedItems.filter{ $0.itemID!.contains(canceledItemID) }.first
                self.availableItems.append(canceledItem!)
                self.consumedItems.removeAll(where: { $0.itemID == "chimps" } )
                self.viewArray.remove(at: index)
                print("number of element = \(self.viewArray.count)")
                self.tblViewDrag.reloadData()
            }
        }
        reusebleview.dataCalbacTap = { name  in
            print("hello world")
            self.viewDetail.isHidden = false
        }
        
        var dragedItem = availableItems[senderIndexPathRow]
        availableItems.remove(at: senderIndexPathRow)
        // seting cordinate to item after adding to map because it is 0,0
       
        dragedItem.coordinateX = Float(dropPoint.x)
        dragedItem.coordinateY = Float(dropPoint.y)

        consumedItems.append(dragedItem)
        // adding view
        viewInSideTable.addSubview(reusebleview)
        self.viewArray.append(reusebleview)
        self.mooveViewss()
        self.tblViewDrag.reloadData()
    }
}
extension ViewController{
    private func registerTableViewCells() {
        tblViewDrag.delegate = self
        tblViewDrag.dataSource = self
        // for draging
        tblViewDrag.dragDelegate = self
        tblViewDrag.dragInteractionEnabled = true
        // for droping
        self.tblViewDrop.dropDelegate = self
        
        let tblCell1 = UINib(nibName: "TableViewCellMap",
                                  bundle: nil)
        self.tblViewDrag.register(tblCell1,
                                forCellReuseIdentifier: "TableViewCellMap")
    }
    
    private func fillDataModels() {
        
        let item11 = MapItems()
        item11.coordinateX = 50
        item11.coordinateY = 50
        item11.name = "LED Bulb"
        item11.description = ""
        item11.photoOfItem = ""
        item11.itemID = "50"
        item11.availability = "true"
        let item22 = MapItems()
        item22.coordinateX = 100
        item22.coordinateY = 100
        item22.name = "Bed"
        item22.description = ""
        item22.photoOfItem = ""
        item22.itemID = "60"
        item22.availability = "true"
        let item33 = MapItems()
        item33.coordinateX = 300
        item33.coordinateY = 300
        item33.name = "AC Samsung"
        item33.description = ""
        item33.photoOfItem = ""
        item33.itemID = "70"
        item33.availability = "true"
        
        let item44 = MapItems()
        item44.coordinateX = 150
        item44.coordinateY = 150
        item44.name = "out Space"
        item44.description = ""
        item44.photoOfItem = ""
        item44.itemID = "80"
        item44.availability = "true"
        let item55 = MapItems()
        item55.coordinateX = 200
        item55.coordinateY = 200
        item55.name = "fan"
        item55.description = ""
        item55.photoOfItem = ""
        item55.itemID = "90"
        item55.availability = "true"
        let item66 = MapItems()
        item66.coordinateX = 200
        item66.coordinateY = 400
        item66.name = "Generator"
        item66.description = ""
        item66.photoOfItem = ""
        item66.itemID = "100"
        item66.availability = "true"
        self.availableItems.append(item11)
        self.availableItems.append(item22)
        self.availableItems.append(item33)
        self.availableItems.append(item44)
        self.availableItems.append(item55)
        self.availableItems.append(item66)

        self.tblViewDrag.reloadData()
        
        
    }
}
class CustomPanGestureRecognizer: UIPanGestureRecognizer {
    var ourCustomValue: String?
}
// ********************************************                                ******************************
                                              // TODO: New add on is hear
//*******************************************                                   *******************************
extension ViewController{
    func renderEquipmentOnMAP() {
       
        // setting custom view
        for (ItemIndx,tempItem) in self.availableItems.enumerated() {
           // let dropPoint = tempItem.coordinate//coordinator.session.location(in: self.viewInSideTable)
            let dropPoint = CGPoint(x: CGFloat(tempItem.coordinateX!), y: CGFloat(tempItem.coordinateY!))

            print("location =======\(dropPoint)")
            let reusebleview = DropView(frame: CGRect(x:dropPoint.x , y:dropPoint.y, width: 50, height: 50))
            reusebleview.lblMain.text = tempItem.name
            reusebleview.itemID = tempItem.itemID!

            reusebleview.dataCalbacCancle = { name  in
                print("Hey there, \(name).")
                if let index = self.viewArray.firstIndex(of: name) {
                    self.viewArray[index].removeFromSuperview()
                    let canceledItemID =  self.viewArray[index].itemID
                    //let canceledItem = self.consumedItems[canceledItemID]
                    let canceledItem = self.consumedItems.filter{ $0.itemID!.contains(canceledItemID) }.first
                    self.availableItems.append(canceledItem!)
                    self.consumedItems.removeAll(where: { $0.itemID! == "chimps" } )
                    self.viewArray.remove(at: index)
                    print("number of element = \(self.viewArray.count)")
                    self.tblViewDrag.reloadData()
                }
            }
            reusebleview.dataCalbacTap = { name  in
                print("hello world")
                self.viewDetail.isHidden = false
            }
            
            //
            let dragedItem = tempItem
            availableItems.removeFirst()
            // seting cordinate to item after adding to map because it is 0,0
            dragedItem.coordinateX = Float(dropPoint.x)
            dragedItem.coordinateY = Float(dropPoint.y)

            consumedItems.append(dragedItem)
            // adding view
            viewInSideTable.addSubview(reusebleview)
            self.viewArray.append(reusebleview)
            self.mooveViewss()
            self.tblViewDrag.reloadData()
            self.tblViewDrop.reloadData()

        }
        
        
    }
    
}

//MARK: calling api
extension ViewController{
    func downloadmapData() {
        callApi(){ response, error, succes in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(MapResponse.self, from: response!)
                print(responseModel)
                if responseModel.success == true{
                    guard let datares = responseModel.data else { return  }
                    guard let datafirst = datares.first else { return  }
                    // guard let mapJason = datafirst.map_jsonData else { return  }
                    guard let mapItemsAll = datafirst.mapItems else { return  }
                    let mapItemArr = self.getAvailAndConsumedItem(mapItemArr: mapItemsAll)
                    self.availableItems = mapItemArr.availItemArr
                    self.consumedItems = mapItemArr.consumedItemArr
//                    DispatchQueue.main.async {
//                        self.tblViewDrag.reloadData()
//                    }
                    
                    //test**
                    
                    DispatchQueue.main.async {
                        
                    let url = URL(string: "http://192.168.88.2:8435/eotServices/\(datafirst.mapImageUrl!)")
                    DispatchQueue.global(qos: .background).async {
                        let data = try? Data(contentsOf: url!)
                        
                        DispatchQueue.main.async {
                            if let imgdata = data{
                                self.imageMap = UIImage(data: imgdata) ?? UIImage(named: "3droom")!
                                self.roomImage.image = self.imageMap//UIImage(data: data!)

                                //
                                self.canvasSizeDefalt = CGSize(width: 0, height: 500)
                              //  self.originalSizeMapImage = self.imageMap.size
                                self.originalSizeMapImage = CGSize(width: datafirst.mapWidth!, height: datafirst.mapLength!)

                                //
                                let reduceAspectRatio = self.canvasSizeDefalt.height/self.originalSizeMapImage.height
                                //reducing to defalt size of canvas that is currentaly heigt = 500
                                let  hight_imgMapAfterDownSacle = self.originalSizeMapImage.height*reduceAspectRatio
                                let  width_imgMapAfterDownSacle = self.originalSizeMapImage.width*reduceAspectRatio

                                self.canvasSizeDefalt = CGSize(width: width_imgMapAfterDownSacle, height: hight_imgMapAfterDownSacle)
                                
                                self.tblViewDrop.frame.size = self.canvasSizeDefalt
                                  self.viewInSideTable.frame.size = self.tblViewDrop.frame.size

                           
                                self.tblHeightConstrents.constant = CGFloat(self.canvasSizeDefalt.height - 500)// 500
                                self.tblWidthConstrents.constant = CGFloat(self.canvasSizeDefalt.width - 383)//417
                                //
                                self.roomImage.frame.size = self.viewInSideTable.frame.size
                            
                            for itemTem in self.consumedItems {
                                itemTem.coordinateX = itemTem.coordinateX! * Float(reduceAspectRatio)
                                itemTem.coordinateY =  itemTem.coordinateY! * Float(reduceAspectRatio)
                            }
                                for itemTem in self.availableItems {
                                    itemTem.coordinateX = itemTem.coordinateX! * Float(reduceAspectRatio)
                                    itemTem.coordinateY =  itemTem.coordinateY! * Float(reduceAspectRatio)
                                }
                                self.renderEquipmentOnMAP()
                        }
                            }
                        }
                    }
                      
                    //test***
                    
                    
                    
                /*    DispatchQueue.main.async {
                        //   roomImage.image = Data(count: <#T##Int#>)
                        self.tblViewDrop.frame.size = CGSize.init(width: datafirst.mapWidth!, height: datafirst.mapLength!)
                        self.viewInSideTable.frame.size = self.tblViewDrop.frame.size
                        
                        
                        let url = URL(string: "http://192.168.88.2:8435/eotServices/\(datafirst.mapImageUrl!)")
                        DispatchQueue.global(qos: .background).async {
                        let data = try? Data(contentsOf: url!)
                            
                            DispatchQueue.main.async {
                                self.roomImage.image = UIImage(data: data!)
                            }
                    }
                       

                        self.roomImage.image = self.imageMap
                        self.roomImage.frame = self.viewInSideTable.frame
                        self.roomImage.contentMode = .scaleToFill
                        self.viewInSideTable.addSubview(self.roomImage)
                        
                        self.tblHeightConstrents.constant = CGFloat(datafirst.mapLength! - 500)// 500
                        self.tblWidthConstrents.constant = CGFloat(datafirst.mapWidth! - 383)//417
                        self.renderEquipmentOnMAP()
                    }*/
                   
                }
                
                
            } catch {
                print("JSON Serialization error")
            }
        }
        
    }
    
    func getAvailAndConsumedItem(mapItemArr : [MapItems]) -> (availItemArr : [MapItems],consumedItemArr : [MapItems]) {
        var availItems = [MapItems]()
        var consumedItems = [MapItems]()
        for item in mapItemArr {
            if item.availability == "true" {
                availItems.append(item)
            }else if item.availability == "false"{
                consumedItems.append(item)
            }
        }
        
        return (availItems,consumedItems)
    }
}


