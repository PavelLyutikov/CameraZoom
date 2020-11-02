//
//  LoadingController.swift
//  CameraZoom
//
//  Created by Sergey Labartkava on 24.06.2020.
//  Copyright © 2020 6connex China. All rights reserved.
//

import UIKit

class LoadingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadAppNow()
    }

//    @IBAction func btnStartApp(_ sender: Any) {
//        loadAppNow()
//    }
    
    func loadAppNow() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
            let previewController = mainStoryboard.instantiateViewController(withIdentifier: "PreviewOne") as! PreviewOneScreen
            
            
            
            if !UserDefaults.standard.bool(forKey: "isFirstLaunch") {
                UIApplication.shared.windows.first!.rootViewController = previewController
            } else {
                UIApplication.shared.windows.first!.rootViewController = viewController
            }
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
    }

}
