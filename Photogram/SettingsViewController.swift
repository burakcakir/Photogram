//
//  SettingsViewController.swift
//  Photogram
//
//  Created by burak on 5.06.2021.
//  Copyright © 2021 burak. All rights reserved.
//

import UIKit // arayüz oluşturmaya yardımcı ios kütüphanesi
import Firebase
import SDWebImage // vt den foto çekip bastırmaya yarar.

class SettingsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

   
    @IBOutlet weak var ppImg: UIImageView!
    
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var userLabel: UILabel!
    
     var userImgArray = [String]()
     var userNameArray = [String]()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        getDataFromFirestore()
        ppImg.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        ppImg.addGestureRecognizer(gestureRecognizer)
        
        

    
    }
    
    
    func getDataFromFirestore() {
         let fireStoreDatabase = Firestore.firestore()
            
        fireStoreDatabase.collection("ppmedia").document(Auth.auth().currentUser!.email!).addSnapshotListener { (snapshot, error) in
                   if error != nil {
                       print(error?.localizedDescription as Any)
                   }else {
                    
                        self.userNameArray.removeAll(keepingCapacity: false)
                        self.userImgArray.removeAll(keepingCapacity: false)
                        
                        if let imgUrl = snapshot?.get("imageUrl") as? String {
                                   self.userImgArray.append(imgUrl)
                        }
                        if let username = snapshot?.get("user") as? String {
                               self.userNameArray.append(username)
                        }
                        
                   }
               }
       
    }
    
    
    @objc func chooseImage(){ // fotoğraf seçmek için galeri açma
          
          let pickerController = UIImagePickerController()
          pickerController.delegate = self
          pickerController.sourceType = .photoLibrary
          present(pickerController,animated: true,completion: nil)
      }
      
      
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // fotoğraf seçildi mi kontrolü
          ppImg.image = info[.originalImage] as? UIImage
          self.dismiss(animated: true, completion: nil)
      }
      
      
      func makeAlert(titleInput:String,messageInput:String) {
          let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
          let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
          alert.addAction(okButton)
          self.present(alert,animated: true,completion: nil)
      }
      
    
    @IBAction func ppKaydet(_ sender: Any) { // ayarlar ekranında kullanıcının profil fotoğrafı.
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("ppmedia")
        	
        if let data = ppImg.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = Auth.auth().currentUser!.uid
                     
                     let imgReference = mediaFolder.child("\(uuid).jpg")
                     imgReference.putData(data, metadata: nil) { (metadata, error) in
                         if error != nil{
                             self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata!")
                         }else{
                             imgReference.downloadURL { (url, error) in
                                 if error == nil{
                                     let imgUrl = url?.absoluteString
                                   	
                                     
                                     let firestoreDatabase = Firestore.firestore()
                                     
                                     var firestoreReference : DocumentReference? = nil
                                     
                                     let firestorePost = ["ppimageUrl" : imgUrl!] as [String : Any]
                                    firestoreDatabase.collection("ppmedia").document(Auth.auth().currentUser!.email!).setData(firestorePost, merge: true)
                                       
                                        self.ppImg.image = UIImage(named: "yukle.jpg")
                                        self.tabBarController?.selectedIndex = 0
   
                                 }
                            }
            
        }
        
        
    }
        }
    }
    
    
    @IBAction func isimGüncelle(_ sender: Any) { // ayarlar ekranında kullanıcı ismi güncelleme
        
        if userTextField.text != "" {
        
            let firestoreDatabase = Firestore.firestore()
            let firestorePost = ["user" : userTextField.text!] as [String : Any]
            
            firestoreDatabase.collection("posts ").document(Auth.auth().currentUser!.email!).setData(firestorePost, merge: true)
            self.userLabel.text = String(userTextField.text!)
            
            
            
            
            
            
        }else{
            self.makeAlert(titleInput: "Hata!", messageInput: "İsim Güncellenemedi!")
            
        }

    }
    
    
    
    @IBAction func cikisYap(_ sender: Any) { // uygulamadan çıkış yapma
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("Hata")
        }
        
    }

    }
  
    
