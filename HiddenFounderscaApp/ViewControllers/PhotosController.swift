//
//  ViewController.swift
//  HiddenFounderscaApp
//
//  Created by mac on 23/05/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import SwiftOverlays
import Firebase
import UICircularProgressRing

class PhotosController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var progressBar: UICircularProgressRingView!

    var album: JSON?
    var photos: [JSON] = []
    var selectedPhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getPhotos(albumId: (album?["id"].string)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setCollectionView(){
        collection.register(UINib(nibName: "PhotoItem", bundle: nil), forCellWithReuseIdentifier: "PhotoItem")
        collection.allowsMultipleSelection = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photos.count)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoItem", for: indexPath as IndexPath) as! PhotoItem
        photo.setPhoto(id: (photos[indexPath.row]["id"].string)!)
        return photo
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 103)
        let height = width * 9/16
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collection.cellForItem(at: indexPath) as! PhotoItem
        if let index = selectedPhotos.index(of: item.image.image!){
            selectedPhotos[0] = item.image.image!
        }else {
           selectedPhotos.append(item.image.image!)
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let item = collection.cellForItem(at: indexPath) as! PhotoItem
//        let index = selectedPhotos.index(of: item.image.image!)
//        if index != nil   {
//            selectedPhotos.remove(at: index!)
//        }
//    }
    
    func getPhotos(albumId: String){
        self.showWaitOverlayWithText("Getting photos ...")
        FBSDKGraphRequest(graphPath: "\(albumId)/photos", parameters: ["fields":"id,name,email,images,link,from,place"], httpMethod: "GET").start(completionHandler: {  (connection, result, error) in
            if((error) != nil){
            }else{
                let res = JSON(result!)
                self.photos = res["data"].arrayValue
                self.collection.reloadData()
                self.removeAllOverlays()
        }
        })
    }
    
    @IBAction func upload(_ sender: Any) {
        self.progressBar.isHidden = false
        let uuid = NSUUID().uuidString
        let database = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference()
        let metaData = FIRStorageMetadata()
        let imageRef = storage.child("images/\(uuid).jpg")
        
        metaData.contentType = "image/jpeg"
        let uploadTask = imageRef.put(UIImageJPEGRepresentation(selectedPhotos[0] , 0.8)!, metadata: metaData)
        
        uploadTask.observe(.progress) { snapshot in
            let value = snapshot.progress!.fractionCompleted
            self.progressBar.setProgress(value: CGFloat( value * 100), animationDuration: 2.0) {
                if(value == 1) {
                    Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.uploadDone), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    func uploadDone() {
        self.progressBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
}

