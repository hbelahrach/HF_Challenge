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

class Home: UIViewController, FBSDKLoginButtonDelegate {
    
    var albums: Array <JSON> = []
    var selectedAlbums: Array <JSON> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends", "user_photos"]
        loginView.delegate = self
        if (FBSDKAccessToken.current() != nil){
            print(FBSDKAccessToken.current().tokenString)
            PreferencesManager.saveToken(token: FBSDKAccessToken.current().tokenString)
            
        }
        getAlbums()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func facebookBtnPressed() {
//        SNManager.loginUsingFacebook(vc: self, delegate: self)
//    }
//    s
//    func loginCompleted(user: SNUser){
//        
//    }



    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        print("User Logged In")
        print(error)
        print(result.isCancelled)
        print(result.token)
        
        if (error != nil || result.isCancelled) {
            // Process error
            print(error)
            print(result)
        }else{
            print("get Albums")
            getAlbums()
        }
        
    }
    
    public func getAlbums(){
        // waiting overlay
        self.showWaitOverlayWithText("Getting albums ...")
        
        FBSDKGraphRequest(graphPath: "/me/albums", parameters: ["fields":"id,name,user_photos"], httpMethod: "GET").start(completionHandler: {  (connection, result, error) in
            if((error) != nil){
            }else{
                PreferencesManager.saveToken(token: FBSDKAccessToken.current().tokenString)
                let res = JSON(result!)
                print("Res: ", res)
                self.albums = res["data"].arrayValue
                let mirror = Mirror(reflecting: res["data"].arrayValue)
                print(mirror.subjectType)
                self.removeAllOverlays()
                self.performSegue(withIdentifier: "Albums_segue", sender: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Albums_segue"){
            let vc = segue.destination as! AlbumsController
            vc.albums = albums
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("User Logged Out")
    }

}

