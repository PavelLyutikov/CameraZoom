//
//  ViewController.swift
//  Dermatology Camera
//
//  Created by Warren Wang on 7/13/18.
//  Copyright © 2018 6connex China. All rights reserved.
//


import UIKit
import AVFoundation
import SnapKit
import PixelSDK
import SwiftyStoreKit


import YPImagePicker
import AVKit
import Photos

import BadgeControl

class CameraViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let totalSize = UIScreen.main.bounds.size
    
    var activityIndicator = UIActivityIndicatorView()
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    var imagePicker: UIImagePickerController?
    private var flashMode: AVCaptureDevice.FlashMode = .off
    private var upperTimerBadge: BadgeController!
    
    
//    var zoomPosit: CGFloat = 0
    
    var flashPositional: Bool = false
    
    // Video
    var camerMode = "photo"
    let movieOutput = AVCaptureMovieFileOutput()

    var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    var hiZooLine : CGFloat!
    var botZooLine : CGFloat!
    var timerTimes: [Int] = [2, 3, 4, 5]
    var timerStstus : Bool = false
    var timerValue : Int = 0
    var recording : Bool = false


    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupActivityIndicator()
//        view.addSubview(activityIndicator)
//
//        activityIndicator.startAnimating()
//
//        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "7a4f4540d67a4d83b9bc477d3601ac80")
//
//        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let receipt):
//                let productId = "com.cameraZoomPro.fullFunctional"
//                let purchaseResult = SwiftyStoreKit.verifySubscription(
//                    ofType: .autoRenewable,
//                    productId: productId,
//                    inReceipt: receipt)
//
//                switch purchaseResult {
//                case .purchased( _, _):
                    // set up camera view
                    self.setupConstructionCamera()

                            
                            // to switch camera
                    self.toggleCameraGestureRecognizer.direction = .up
                    self.toggleCameraGestureRecognizer.addTarget(self, action: #selector(self.switchCamera))
                    self.view.addGestureRecognizer(self.toggleCameraGestureRecognizer)
                            
                            // to Zoom In
                    self.zoomInGestureRecognizer.direction = .right
                    self.zoomInGestureRecognizer.addTarget(self, action: #selector(self.zoomIn))
                    self.view.addGestureRecognizer(self.zoomInGestureRecognizer)
                            
                    //         to Zoom Out
                    self.zoomOutGestureRecognizer.direction = .left
                    self.zoomOutGestureRecognizer.addTarget(self, action: #selector(self.zoomOut))
                            
                    self.view.addGestureRecognizer(self.zoomOutGestureRecognizer)
                            
                    self.galleryButton.addTarget(self, action: #selector(self.galleryAction(sender:)), for: .touchUpInside)

                    self.timeButton.addTarget(self, action: #selector(self.timeAction(sender:)), for: .touchUpInside)
                            
                    self.settingButton.addTarget(self, action: #selector(self.settingAction(sender:)), for: .touchUpInside)
                            
                    self.videoButton.addTarget(self, action: #selector(self.videoAction(sender:)), for: .touchUpInside)
                            
                    self.cameraButton.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)
                            
                    self.zoomInButton.addTarget(self, action: #selector(self.zoomOut), for: .touchUpInside)
                            
                            
                    self.zoomOutButton.addTarget(self, action: #selector(self.zoomIn), for: .touchUpInside)
                            
                            
                       
                            
                            
                            
//                            // VIDEO
//                    if self.setupSession() {
//                                
//                            }
//                    self.upperTimerBadge = BadgeController(for: self.timeButton, in: .upperRightCorner, badgeBackgroundColor: UIColor.clear , badgeTextColor: UIColor.white, borderWidth: 0, badgeHeight: 20)
//                case .expired( _, _):
//                    self.showFourScreen()
//                case .notPurchased:
//                    self.showFourScreen()
//                }
//
//            case .error( _):
//                self.showFourScreen()
//            }
//            
//            self.activityIndicator.stopAnimating()
//        }
        
    }
    
    private func showFourScreen() {
        let vc = PreviewFourScreen()

        vc.modalPresentationStyle = .fullScreen

        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        view.window!.layer.add(transition, forKey: kCATransition)

        present(vc, animated: false, completion: nil)
    }
    
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        activityIndicator.hidesWhenStopped = true
    }
    
    
    
    // Video

     //MARK:- Setup Camera

     func setupSession() -> Bool {
     
         captureSession.sessionPreset = AVCaptureSession.Preset.high
     
         // Setup Camera
         let camera = AVCaptureDevice.default(for: AVMediaType.video)!
     
         do {
         
             let input = try AVCaptureDeviceInput(device: camera)
         
             if captureSession.canAddInput(input) {
                 captureSession.addInput(input)
                 activeInput = input
             }
         } catch {
             print("Error setting device video input: \(error)")
             return false
         }
     
         // Setup Microphone
         let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
     
         do {
             let micInput = try AVCaptureDeviceInput(device: microphone)
             if captureSession.canAddInput(micInput) {
                 captureSession.addInput(micInput)
             }
         } catch {
             print("Error setting device audio input: \(error)")
             return false
         }
     
     
         // Movie output
         if captureSession.canAddOutput(movieOutput) {
             captureSession.addOutput(movieOutput)
         }
     
         return true
     }

     func setupCaptureMode(_ mode: Int) {
         // Video Mode
     
     }

     //MARK:- Camera Session


     func stopSession() {
         if captureSession.isRunning {
             videoQueue().async {
                 self.captureSession.stopRunning()
             }
         }
     }

     func videoQueue() -> DispatchQueue {
         return DispatchQueue.main
     }

     func currentVideoOrientation() -> AVCaptureVideoOrientation {
         var orientation: AVCaptureVideoOrientation
     
         switch UIDevice.current.orientation {
             case .portrait:
                 orientation = AVCaptureVideoOrientation.portrait
             case .landscapeRight:
                 orientation = AVCaptureVideoOrientation.landscapeLeft
             case .portraitUpsideDown:
                 orientation = AVCaptureVideoOrientation.portraitUpsideDown
             default:
                  orientation = AVCaptureVideoOrientation.landscapeRight
          }
     
          return orientation
      }

     @objc func startCapture() {
     
         startRecording()
     
     }

     //EDIT 1: I FORGOT THIS AT FIRST

     func tempURL() -> URL? {
         let directory = NSTemporaryDirectory() as NSString
     
         if directory != "" {
             let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
             return URL(fileURLWithPath: path)
         }
     
         return nil
     }

     

     
     
     func startRecording() {
     
         if movieOutput.isRecording == false {
         
             let connection = movieOutput.connection(with: AVMediaType.video)
         
             if (connection?.isVideoOrientationSupported)! {
                 connection?.videoOrientation = currentVideoOrientation()
             }
         
             if (connection?.isVideoStabilizationSupported)! {
                 connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
             }
         
             let device = currentDevice
         
            if (device!.isSmoothAutoFocusSupported) {
             
                 do {
                    try device!.lockForConfiguration()
                    device!.isSmoothAutoFocusEnabled = false
                    device!.unlockForConfiguration()
                 } catch {
                    print("Error setting configuration: \(error)")
                 }
             
             }
            
            recording = true
             //EDIT2: And I forgot this
             outputURL = tempURL()
             movieOutput.startRecording(to: outputURL, recordingDelegate: self)
             cameraButton.setImage(#imageLiteral(resourceName: "tap-recordstop"), for: .normal)
                    // Запускаем таймер
             }
             else {
                 stopRecording()
                 cameraButton.setImage(#imageLiteral(resourceName: "tap-recordstart.png"), for: .normal)
                    // Убираем таймер
             }
        
        
     
        }
    
    func photoShot () {
        let settings = AVCapturePhotoSettings()
        //        photoOutput?.capturePhoto(with: settings, delegate: self)
                if flashPositional == true {
                    settings.flashMode = flashMode
                }
        //        flashMode = .on
                
        //        settings = getSettings(camera: cameraView, flashMode: flashMode)
                photoOutput?.capturePhoto(with: settings, delegate: self)
    }


     func stopRecording() {
        
        recording = false
     
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
         }
    }
    
    // video end ---
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func setupConstructionCamera() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        addSubView()
        
        zoomPositional.isHidden = false
        zoomCoursore.isHidden = false
        centr.isHidden = false
        corner.isHidden = false
        cornerTwo.isHidden = false
        cornerThree.isHidden = false
        cornerFour.isHidden = false
        
    }
    
//MARK: - CameraView
        lazy var cameraView: UIImageView =  {
            var cameraView = UIImageView()
            
    //        cameraView.backgroundColor = .white
            cameraView.clipsToBounds = true
    //        cameraView.layer.cornerRadius = 5
            cameraView.contentMode = .scaleAspectFit
            self.view.addSubview(cameraView)
            
//            var constant: CGFloat!
//                 if totalSize.height >= 815 {
//                    constant = 605
//                 } else if totalSize.height <= 700 {
//                    constant = 440
//                 } else if totalSize.height == 812 {
//                    constant = 520
//                 } else {
//                    constant = 510
//            }
            
            var constant: CGFloat!
             if totalSize.height >= 815 {
                constant = 605
             } else if totalSize.height >= 700 {
                constant = 510
             } else if totalSize.height == 812 {
                constant = 520
             } else if totalSize.height >= 600 {
                 constant = 440
             } else {
                constant = 350
            }
            
            cameraView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.center.equalToSuperview()
    //            make.height.equalTo(UIScreen.main.bounds.width)
                make.height.equalTo(constant)
            }
            return cameraView
        }()
//    private func setupViews() {
//        self.view.backgroundColor = .black
//        cameraView.isHidden = false
//    }
    
    
//MARK: - ZoomInButton
    @objc lazy var zoomInButton: UIButton = {
        
        var constant: CGFloat!
                var left: CGFloat!
                var size: CGFloat!
                 if totalSize.height >= 800 {
                    constant = 30
                    left = 40
                    size = 60
                } else {
                    constant = 10
                    left = 40
                    size = 55
                }
                
                let btn = UIButton()
                
                btn.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
        //        btn.setTitle("ФОТО", for: .normal)
                btn.setTitleColor(.white, for: .normal)
                self.view.addSubview(btn)

                btn.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset(left)
                    make.bottom.equalToSuperview().inset(16)
                    make.height.width.equalTo(size)
                    make.bottom.equalToSuperview().inset(constant)
                }
                
                return btn
    }()
//MARK: - ZoomOutButton
        @objc lazy var zoomOutButton: UIButton = {
            
            var constant: CGFloat!
                    var right: CGFloat!
                    var size: CGFloat!
                     if totalSize.height >= 800 {
                        constant = 30
                        right = 40
                        size = 60
                    } else {
                        constant = 10
                        right = 40
                        size = 55
                    }
                    
                    let btn = UIButton()
                    
                    btn.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
            //        btn.setTitle("ФОТО", for: .normal)
                    btn.setTitleColor(.white, for: .normal)
                    self.view.addSubview(btn)

                    btn.snp.makeConstraints { make in
                        make.trailing.equalToSuperview().inset(right)
                        make.bottom.equalToSuperview().inset(16)
                        make.height.width.equalTo(size)
                        make.bottom.equalToSuperview().inset(constant)
                    }
                    
                    return btn
        }()
//MARK: - ZoomPositional
        @objc lazy var zoomPositional: UIImageView = {

//            var heidth: CGFloat!
//            var width: CGFloat!
//                 if totalSize.height >= 815 {
//                    heidth = 480
//                    width = 20
//                 } else if totalSize.height <= 700 {
//                    heidth = 350
//                    width = 16
//                 } else if totalSize.height == 812 {
//                    heidth = 400
//                    width = 18
//                 } else {
//                    heidth = 400
//                    width = 18
//            }
            
            var heidth: CGFloat!
            var width: CGFloat!
                 if totalSize.height >= 815 {
                    heidth = 480
                    width = 20
                 } else if totalSize.height >= 700 {
                    heidth = 400
                    width = 18
                 } else if totalSize.height == 812 {
                    heidth = 400
                    width = 18
                 } else if totalSize.height >= 600 {
                    heidth = 350
                    width = 16
                 } else {
                    heidth = 280
                    width = 14
                }
            
            hiZooLine = heidth
            
            let zoom = UIImageView()
            zoom.image = #imageLiteral(resourceName: "zoom")
            zoom.layer.zPosition = 100

            self.view.addSubview(zoom)

            zoom.snp.makeConstraints { make in
    //            make.trailing.equalToSuperview().inset(right)
                make.height.equalTo(heidth)
                make.width.equalTo(width)
                make.leading.equalToSuperview().inset(35)
                make.centerY.equalToSuperview()
            }
            
            return zoom
            
        }()
    //MARK: - ZoomCoursore
        @objc lazy var zoomCoursore: UIImageView = {
            
//            var bottom: CGFloat!
//            var size: CGFloat!
//            var heidth: CGFloat!
//            var width: CGFloat!
//             if totalSize.height >= 800 {
//                bottom = 222
//                size = 10
//            } else {
//                bottom = 202
//                size = 10
//            }
            
            var bottom: CGFloat!
            var size: CGFloat!
            var heidth: CGFloat!
            var width: CGFloat!
                 if totalSize.height >= 815 {
                    bottom = 222
                    size = 10
                 } else if totalSize.height <= 700 {
                    bottom = 170
                    size = 10
                 } else if totalSize.height == 812 {
                    bottom = 222
                    size = 10
                 } else {
                    bottom = 222
                    size = 10
            }
            botZooLine = bottom
            let zoomCour = UIImageView()
                    zoomCour.image = #imageLiteral(resourceName: "zoomcoursore")
                    zoomCour.layer.zPosition = 100
                    self.view.addSubview(zoomCour)

                    zoomCour.snp.makeConstraints { make in
                        make.height.width.equalTo(size)
                        make.leading.equalToSuperview().inset(42)
                        make.bottom.equalToSuperview().inset(bottom)
                    }
            
            
            return zoomCour
            
        }()
    

//MARK: - GalleryButton
    @objc lazy var galleryButton: UIButton = {
        
        var constant: CGFloat!
        var left: CGFloat!
             if totalSize.height >= 815 {
                constant = 70
                left = 50
             } else if totalSize.height <= 700 {
                constant = 45
                left = 40
             } else if totalSize.height == 812 {
                constant = 75
                left = 40
             } else {
                constant = 50
                left = 50
        }
        
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "image"), for: .normal)
//        btn.setTitle("ФОТО", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        self.view.addSubview(btn)

        btn.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(left)
            make.height.width.equalTo(40)
            make.top.equalToSuperview().inset(constant)
        }
        
        return btn
    }()
    @objc func galleryAction(sender: UIButton) {
        
        var config = YPImagePickerConfiguration()

        config.library.mediaType = .photoAndVideo

        config.startOnScreen = .library

        config.wordings.libraryTitle = "Gallery"

        config.hidesStatusBar = false
        
        config.hidesBottomBar = true
        
        let picker = YPImagePicker(configuration: config)

        

        /* Multiple media implementation */
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }

        }
        present(picker, animated: true, completion: nil)
        
    }
    
//MARK: - PhotoButton
    @objc lazy var cameraButton: UIButton = {
        
        var constant: CGFloat!
        var size: CGFloat!
         if totalSize.height >= 800 {
            constant = 30
            size = 65
        } else {
            constant = 10
            size = 60
        }
        
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "tap"), for: .normal)
//        btn.setTitle("ФОТО", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        self.view.addSubview(btn)

        btn.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview().inset(16)
            make.height.width.equalTo(size)
            make.bottom.equalToSuperview().inset(constant)
        }
        
        return btn
    }()
    
    
    
    
    @objc func buttonAction(sender: UIButton) {
        var timer : Timer?
        
        if (camerMode == "photo"){
        
            if timerStstus == false {
                photoShot()
            } else {
                cameraButton.isEnabled = false
                cameraButton.setImage(nil, for: .normal)
                cameraButton.setTitle("ФОТО", for: .normal)
                var secondsRemaining = timerTimes[timerValue]
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining > 0 {
                        print ("\(secondsRemaining) seconds")
                        self.cameraButton.setTitle("\(secondsRemaining)", for: .normal)
                        secondsRemaining -= 1
                    } else {
                        timer!.invalidate()
                        self.photoShot()
                        self.cameraButton.isEnabled = true
                        self.cameraButton.setImage(#imageLiteral(resourceName: "tap"), for: .normal)
                    }
                }
                
                
            }
            

        }
         if (camerMode == "video"){
            if timerStstus == false {
                startRecording()
            } else {
                if recording == true {
                    startRecording()
                } else {
//                cameraButton.isEnabled = false
                cameraButton.setImage(nil, for: .normal)
//                cameraButton.setTitle("ФОТО", for: .normal)
                var secondsRemaining = timerTimes[timerValue]
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                    if secondsRemaining > 0 {
                        print ("\(secondsRemaining) seconds")
                        self.cameraButton.setTitle("\(secondsRemaining)", for: .normal)
                        secondsRemaining -= 1
                    } else {
                        timer!.invalidate()
                        self.startRecording()
//                        self.cameraButton.isEnabled = true
//                        self.cameraButton.setImage(#imageLiteral(resourceName: "tap"), for: .normal)
                    }
                    }
                }
                
                
            }
            
            
        }

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showPhotoSegue" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
        }
        
        if segue.identifier == "showVideo" {
            let vc = segue.destination as! VideoPlayback
            vc.videoURL = (sender as! URL)
        }
    }
//MARK: - SettingButton
        @objc lazy var settingButton: UIButton = {
            
            var constant: CGFloat!
            var right: CGFloat!
                 if totalSize.height >= 815 {
                    constant = 70
                    right = 50
                 } else if totalSize.height <= 700 {
                    constant = 45
                    right = 40
                 } else if totalSize.height == 812 {
                    constant = 75
                    right = 40
                 } else {
                    constant = 50
                    right = 50
            }
            
            let btn = UIButton()
            
            btn.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
            btn.setTitle("ФОТО", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(right)
                make.height.width.equalTo(40)
                make.top.equalToSuperview().inset(constant)
            }
            
            return btn
        }()
    @objc func settingAction(sender: UIButton) {

        let vc = UINavigationController(rootViewController: SettingTableViewController())
        
            vc.modalPresentationStyle = .fullScreen
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
            view.window!.layer.add(transition, forKey: kCATransition)
            
        present(vc, animated: false, completion: nil)
        }
//MARK: - TimeButton
        @objc lazy var timeButton: UIButton = {
            
//            var constant: CGFloat!
//            var right: CGFloat!
//                 if totalSize.height >= 815 {
//                    constant = 70
//                    right = 145
//                 } else if totalSize.height <= 700 {
//                    constant = 45
//                    right = 130
//                 } else if totalSize.height == 812 {
//                    constant = 75
//                    right = 125
//                 } else {
//                    constant = 50
//                    right = 140
//            }
            
            var constant: CGFloat!
            var right: CGFloat!
                 if totalSize.height >= 815 {
                    constant = 70
                    right = 145
                 } else if totalSize.height >= 700 {
                    constant = 45
                    right = 140
                 } else if totalSize.height == 812 {
                    constant = 75
                    right = 125
                 } else if totalSize.height >= 600 {
                    constant = 45
                    right = 125
                 } else {
                    constant = 45
                    right = 110
                }
            
            let btn = UIButton()
            
            btn.setImage(#imageLiteral(resourceName: "timer"), for: .normal)
            btn.setTitle("ФОТО", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(right)
                make.height.equalTo(40)
                make.width.equalTo(35)
                make.top.equalToSuperview().inset(constant)
            }
            
            return btn
        }()
    @objc func timeAction(sender: UIButton) {
                        
        
            // Смотри какой эоемент уже выбран
            //var timerTimes: [Int] = [2, 3, 4, 5]
            //var timerStstus : Bool = false
            //var timerValue : Int = 0
            if (timerStstus == false){
                timerStstus = true
                timerValue = 0
                
                upperTimerBadge.addOrReplaceCurrent(with: String(timerTimes[timerValue]), animated: true)
                
            }else{
  
                if (timerTimes.count > timerValue + 1 ) {
                    timerValue += 1
                    upperTimerBadge.addOrReplaceCurrent(with: String(timerTimes[timerValue]), animated: true)
                }else{
                    timerStstus = false
                    upperTimerBadge.addOrReplaceCurrent(with: "", animated: true)
                }
                
            }
            upperTimerBadge.animateOnlyWhenBadgeIsNotYetPresent = true
            upperTimerBadge.animation = BadgeAnimations.leftRight
            
            
            
        }
    
//MARK: ToggleTimer
    @objc func toggleCameraTimer() {
        if flashMode == .on {
            flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "on"), for: .normal)
            flashPositional = false
        } else {
            flashMode = .on
            flashPositional = true
            toggleFlashButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
        }
    }
    
//MARK: - FlashButton
        @objc lazy var toggleFlashButton: UIButton = {

//            var constant: CGFloat!
//            var left: CGFloat!
//                 if totalSize.height >= 815 {
//                    constant = 70
//                    left = 140
//                 } else if totalSize.height <= 700 {
//                    constant = 45
//                    left = 125
//                 } else if totalSize.height == 812 {
//                    constant = 75
//                    left = 125
//                 } else {
//                    constant = 50
//                    left = 140
//            }
            
            var constant: CGFloat!
            var left: CGFloat!
                 if totalSize.height >= 815 {
                    constant = 70
                    left = 140
                 } else if totalSize.height >= 700 {
                    constant = 50
                    left = 140
                 } else if totalSize.height == 812 {
                    constant = 75
                    left = 125
                 } else if totalSize.height >= 600 {
                    constant = 45
                    left = 125
                 } else {
                    constant = 45
                    left = 105
                }
            
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "on"), for: .normal)
            btn.setTitleColor(.white, for: .normal)
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(left)
                make.height.equalTo(40)
                make.width.equalTo(43)
                make.top.equalToSuperview().inset(constant)
            }
            btn.addTarget(self, action: #selector(toggleCameraFlash), for: .touchUpInside)
            btn.layer.zPosition = 1
            btn.translatesAutoresizingMaskIntoConstraints = false
            
            return btn

        }()
    //MARK: Toggle Flash
    @objc func toggleCameraFlash() {
        if flashMode == .on {
            flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "on"), for: .normal)
            flashPositional = false
        } else {
            flashMode = .on
            flashPositional = true
            toggleFlashButton.setImage(#imageLiteral(resourceName: "off"), for: .normal)
        }
    }
    
    fileprivate func addSubView() {

        [toggleFlashButton].forEach{view.addSubview(($0))}
    }
    
//MARK: - FlashButtonVideo
//    @objc lazy var toggleFlashButtonVideo: UIButton = {
//
//        var constant: CGFloat!
//        var left: CGFloat!
//             if totalSize.height >= 815 {
//                constant = 70
//                left = 160
//             } else if totalSize.height <= 700 {
//                constant = 45
//                left = 145
//             } else if totalSize.height == 812 {
//                constant = 75
//                left = 145
//             } else {
//                constant = 50
//                left = 160
//        }
//
//        let btn = UIButton()
//        btn.setImage(#imageLiteral(resourceName: "on"), for: .normal)
//        btn.setTitleColor(.white, for: .normal)
//        self.view.addSubview(btn)
//
//        btn.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(left)
//            make.height.equalTo(40)
//            make.width.equalTo(43)
//            make.top.equalToSuperview().inset(constant)
//        }
//        btn.addTarget(self, action: #selector(toggleCameraFlash), for: .touchUpInside)
//        btn.layer.zPosition = 1
//        btn.translatesAutoresizingMaskIntoConstraints = false
//
//        return btn
//
//    }()
//
//    var onOff = false
//
//    func toggleTorch(on:Bool) {
//    guard let device = AVCaptureDevice.default(for: .video) else { return }
//
//            if device.hasTorch {
//                do {
//                    try device.lockForConfiguration()
//
//                    if onOff == true {
//                        device.torchMode = .on
//                        print("flashlight on")
//                    }
//                    else {
//                        device.torchMode = .off
//                    }
//
//                    device.unlockForConfiguration()
//                }
//                catch {
//                    print("Torch could not be used")
//                }
//            }
//            else {
//                print("Torch is not available")
//            }
//
//        }
//
//      @objc func flashVideoAction(sender: UIButton) {
//
//        if onOff == false {
////                statusLabel.text = "OFF"
//            toggleFlashButtonVideo.setImage(#imageLiteral(resourceName: "on"), for: .normal)
//           }
//
//            else {
////                statusLabel.text = "ON"
//            toggleFlashButtonVideo.setImage(#imageLiteral(resourceName: "off"), for: .normal)
//            }
//            onOff = !onOff
//
//        toggleTorch(on: true)
//
//          }
//MARK: - VideoButton
        @objc lazy var videoButton: UIButton = {
            
            var constant: CGFloat!
            var sizeH: CGFloat!
            var sizeW: CGFloat!
             if totalSize.height >= 800 {
                constant = 110
                sizeH = 23
                sizeW = 160
            } else {
                constant = 85
                sizeH = 20
                sizeW = 150
            }
            
            let btn = UIButton()
            
            btn.setImage(#imageLiteral(resourceName: "video"), for: .normal)
            btn.setTitle("ФОТО", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            self.view.addSubview(btn)

            btn.snp.makeConstraints { make in
                make.bottom.centerX.equalToSuperview().inset(16)
                make.width.equalTo(sizeW)
                make.height.equalTo(sizeH)
                make.bottom.equalToSuperview().inset(constant)
            }
            
            return btn
        }()

    
    
    @objc func videoAction(sender: UIButton) {
            print ("trogle")
            
            let newZoomFactor : CGFloat = 1
        
            if camerMode == "photo" {

                camerMode = "video"
                cameraButton.setImage(#imageLiteral(resourceName: "tap-recordstart.png"), for: .normal)
                videoButton.setImage(#imageLiteral(resourceName: "videoEndble.png"), for: .normal)
                
            } else {
                camerMode = "photo"
                cameraButton.setImage(#imageLiteral(resourceName: "tap"), for: .normal)
                videoButton.setImage(#imageLiteral(resourceName: "video"), for: .normal)
            }
        
            do {
                
                try currentDevice?.lockForConfiguration()
                currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                currentDevice?.unlockForConfiguration()
                
                
            } catch {
                print(error)
            }
        }
    
//MARK: - SpawnCornet
            @objc lazy var corner: UIImageView = {
                
                var top: CGFloat!
                var left: CGFloat!
                var size: CGFloat!
                 if totalSize.height >= 800 {
                    left = 50
                    top = 160
                    size = 70
                } else {
                    left = 40
                    top = 130
                    size = 55
                }
                
                let leftTop = UIImageView()
                leftTop.image = #imageLiteral(resourceName: "angle1")
                leftTop.layer.zPosition = 100
                self.view.addSubview(leftTop)

                leftTop.snp.makeConstraints { make in
                    make.height.width.equalTo(size)
                    make.leading.equalToSuperview().inset(15)
                    make.top.equalToSuperview().inset(top)
                }
                
                return leftTop
                
            }()
        
    @objc lazy var cornerTwo: UIImageView = {
                
                var bottom: CGFloat!
                var size: CGFloat!
                 if totalSize.height >= 800 {
                    bottom = 160
                    size = 70
                } else {
                    bottom = 130
                    size = 55
                }
                
                let leftBottom = UIImageView()
                        leftBottom.image = #imageLiteral(resourceName: "angle3")
                        leftBottom.layer.zPosition = 100
                        self.view.addSubview(leftBottom)

                        leftBottom.snp.makeConstraints { make in
                            make.height.width.equalTo(size)
                            make.leading.equalToSuperview().inset(15)
                            make.bottom.equalToSuperview().inset(bottom)
                        }
                
                return leftBottom
                
            }()
    
        
        @objc lazy var cornerThree: UIImageView = {
                    
                    var top: CGFloat!
                    var size: CGFloat!
                     if totalSize.height >= 800 {
                        top = 160
                        size = 70
                    } else {
                        top = 130
                        size = 55
                    }
                    
                    let rightTop = UIImageView()
                    rightTop.image = #imageLiteral(resourceName: "angle2")
                    rightTop.layer.zPosition = 100
                    self.view.addSubview(rightTop)

                    rightTop.snp.makeConstraints { make in
                        make.height.width.equalTo(size)
                        make.trailing.equalToSuperview().inset(15)
                        make.top.equalToSuperview().inset(top)
                    }
                    
                    return rightTop
                    
                }()
            
        @objc lazy var cornerFour: UIImageView = {
            
            var bottom: CGFloat!
            var size: CGFloat!
                 if totalSize.height >= 815 {
                    bottom = 160
                    size = 70
                 } else if totalSize.height <= 700 {
                    bottom = 130
                    size = 55
                 } else if totalSize.height == 812 {
                    bottom = 160
                    size = 70
                 } else {
                    bottom = 130
                    size = 55
                 }
                    
                    let rightBottom = UIImageView()
                            rightBottom.image = #imageLiteral(resourceName: "angle4")
                            rightBottom.layer.zPosition = 100
                            self.view.addSubview(rightBottom)

                            rightBottom.snp.makeConstraints { make in
                                make.height.width.equalTo(size)
                                make.trailing.equalToSuperview().inset(15)
                                make.bottom.equalToSuperview().inset(bottom)
                            }
                    
                    return rightBottom
                    
                }()
    //MARK: - SpawnCentr
        @objc lazy var centr: UIImageView = {
            
            var size: CGFloat!
             if totalSize.height >= 800 {
                size = 70
            } else {
                size = 55
            }
            
            let cntr = UIImageView()
            cntr.image = #imageLiteral(resourceName: "centr")
            cntr.layer.zPosition = 100
    //        ctnr.setImage(#imageLiteral(resourceName: "centr"), for: .normal)
    //        ctnr.setTitle("ФОТО", for: .normal)
    //        ctnr.setTitleColor(.white, for: .normal)
            self.view.addSubview(cntr)

            cntr.snp.makeConstraints { make in
    //            make.trailing.equalToSuperview().inset(right)
                make.height.width.equalTo(size)
                make.center.equalToSuperview()
            }
            
            return cntr
        }()
//MARK:- CameraSetting
    func setupCaptureSession() {
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
        }
        
        func setupDevice() {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            
            let devices = deviceDiscoverySession.devices
            
            for device in devices {
                if device.position == AVCaptureDevice.Position.back {
                    backCamera = device
                }
                else if device.position == AVCaptureDevice.Position.front {
                    frontCamera = device
                }
            }
            currentDevice = backCamera
        }
        
        func setupInputOutput() {
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            } catch {
                print(error)
            }
        }
        
        func setupPreviewLayer() {
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            cameraPreviewLayer?.frame = self.view.frame
            cameraView.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        }
        
        func startRunningCaptureSession() {
            captureSession.startRunning()
            
        }
        
        @objc func switchCamera() {
            captureSession.beginConfiguration()
            
            // Change the device based on the current camera
            let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera
            
            // Remove all inputs from the session
            for input in captureSession.inputs {
                captureSession.removeInput(input as! AVCaptureDeviceInput)
            }
            
            // Change to the new input
            let cameraInput:AVCaptureDeviceInput
            do {
                cameraInput = try AVCaptureDeviceInput(device: newDevice!)
            } catch {
                print(error)
                return
            }
            
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            }
            
            currentDevice = newDevice
            captureSession.commitConfiguration()
        }
       //MARK: - Zoom
        @objc func zoomIn() {
            let maxZF = currentDevice?.maxAvailableVideoZoomFactor
            let maxPos : CGFloat = maxZF!
            let zooStep = hiZooLine / maxZF!
            if let zoomFactor = currentDevice?.videoZoomFactor {
                if zoomFactor >= 1.0 {
                    
                    var newZoomFactor = min(zoomFactor + 1.0, 100.0)

                    if (newZoomFactor >= maxPos){ newZoomFactor = maxPos }
                    if (newZoomFactor <= maxPos ) {zoomCoursore.center.y = totalSize.height + 35 - (newZoomFactor * zooStep + botZooLine)}

                    if (newZoomFactor <= maxPos) {
                    do {
                        try currentDevice?.lockForConfiguration()
                        currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                        currentDevice?.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                    }
                } else if zoomFactor >= 5.0 {
                    let newZoomFactor = min(zoomFactor + 10.0, 100.0)
                    if (newZoomFactor <= maxPos) {
                    do {
                        try currentDevice?.lockForConfiguration()
                        currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                        currentDevice?.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                    }
                }
                
            
            }
            
            
            
            
        }
        
        @objc func zoomOut() {
            let maxZF = currentDevice?.maxAvailableVideoZoomFactor
            let minPos : CGFloat = 1.0
            let zooStep = hiZooLine / maxZF!
            if let zoomFactor = currentDevice?.videoZoomFactor {
                if zoomFactor >= 1.0 {
                    let newZoomFactor = max(zoomFactor - 5.0, 1.0)
                    
                    print("ZoomOut")
                    print(newZoomFactor)
                    
                    if (newZoomFactor == minPos){ zoomCoursore.center.y = totalSize.height - 5 - botZooLine }
                    if (newZoomFactor > minPos ) {zoomCoursore.center.y = totalSize.height - (newZoomFactor * zooStep + botZooLine)}
                    

                    do {
//                        zoomPosit += 20
                        try currentDevice?.lockForConfiguration()
                        currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                        currentDevice?.unlockForConfiguration()
                        
                        
                        
                    } catch {
                        print(error)
                    }

                }
            }
    }
    
//private func selfTimerInterval() -> Int {
//    switch timerControl.selectedSegmentIndex {
//    case 0:
//        return 0
//    case 1:
//        return 2
//    case 2:
//        return 5
//    case 3:
//        return 10
//    default:
//        return 0
//    }
//}
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let imageData = photo.fileDataRepresentation() {
            print(imageData)
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showPhotoSegue", sender: nil)
        }
    }
}


extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            
            let videoRecorded = outputURL! as URL
            
            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
        }
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    
        if (error != nil) {
        
            print("Error recording movie: \(error!.localizedDescription)")
        
        } else {
        
            let videoRecorded = outputURL! as URL
        
            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
        
        }
    
    }
}
