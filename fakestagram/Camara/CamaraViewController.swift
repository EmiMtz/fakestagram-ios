//
//  CamaraViewController.swift
//  fakestagram
//
//  Created by Emiliano Alfredo Martinez Vazquez D3 on 5/4/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import AVFoundation
import UIKit
import CoreLocation

class CamaraViewController: UIViewController {

    
    let locationManager = CLLocationManager()
    let client = CreatePostClient()
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableBasicLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        super.viewWillAppear(animated)
    }
    

    
    
    
    @IBAction func onTapCapture(_ sender: Any) {
//        let img = UIImage(named: "church")!
//        CreatePost(img: img)
        
        choosePicture()
        print("posting....")

    }
    
    @IBAction func onTapSnap(_ sender: UIButton) {
//        guard let img = UIImage(named: "1"),
//            let imgBase64 = img.encodedBase64() else { return }
//            let payload = CreatePostBase64(title: "Tac - \(Date().currentTimestamp())",
//                        imageData: imgBase64)
//                    client.create(body: payload) { post in
//                    print(post)
//                        }
//        choosePicture()
    //    CreatePost(img: <#T##UIImage#>)

                print("posting....")
                let img = UIImage(named: "church")!
                createPost(img: img)
    }
    
    @objc func choosePicture(){
        
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Biblioteca", style: .default, handler: { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(actionSheet,animated: true, completion: nil)
        
    }
    
    func enableBasicLocationServices(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Disable location features")
        case .authorizedWhenInUse, .authorizedAlways:
            print("Enable location features")
        }
    }
        
        func createPost(img: UIImage){
            guard let imgBase64 = img.encodedBase64() else {return}
            let timestamp = Date().currentTimestamp()
            client.create(title: String(timestamp), imageData: imgBase64, location: currentLocation) { post in
                print(post)
            }
    }
    
    /*
     // MARK: - Navigation
     @IBAction func onTap(_ sender: Any) {
     }
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CamaraViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       self.currentLocation = locations.last
    }
}

extension CamaraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        
        guard let imagen = info[.editedImage]as? UIImage else {return}
        //createPost(img: imagen)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
