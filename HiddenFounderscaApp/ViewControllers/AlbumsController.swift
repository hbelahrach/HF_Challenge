//
//  AlbumsController.swift
//  HiddenFounderscaApp
//
//  Created by mac on 19/06/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import SwiftOverlays
import SDWebImage

class AlbumsController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collection: UICollectionView!
    @IBOutlet var imagetest: UIImageView!
    var albums: [JSON]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collection.register(UINib(nibName: "AlbumItem", bundle: nil), forCellWithReuseIdentifier: "AlbumItem")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (albums?.count)!
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumItem", for: indexPath as IndexPath) as! AlbumItem
        album.setAlbum(id: (albums?[indexPath.row]["id"].string)!, title: (albums?[indexPath.row]["name"].string)!)
        return album
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 43)/2
        let height = width * 9/16
        return CGSize(width: width , height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums?[indexPath.row]
        self.performSegue(withIdentifier: "Photos_segue", sender: album)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Photos_segue"){
            let vc: PhotosController = segue.destination as! PhotosController
            vc.album = sender as! JSON
        }
    }
}

