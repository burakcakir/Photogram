//
//  UploadViewController.swift
//  Photogram
//
//  Created by burak on 5.06.2021.
//  Copyright © 2021 burak. All rights reserved.
//

import UIKit // arayüz oluşturmaya yardımcı ios kütüphanesi
import Firebase

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imgView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseImage(){ // fotoğraf seçmek için galeri açma
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true,completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // fotoğraf seçildi mi kontrolü
        imgView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func makeAlert(titleInput:String,messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    


    @IBAction func fotoYukle(_ sender: Any) { // post paylaşmadaki fotoğrafı yükleme 
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imgView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
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
                            
                            let docref = firestoreDatabase.collection("ppmedia").document(Auth.auth().currentUser!.email!)
                            
                            docref.getDocument { (document, error) in
                                if let document = document, document.exists{
                                    let dataDescription = document.data()
                                    let userName = dataDescription!["user"] as? String ?? Auth.auth().currentUser!.email!
                                    let ppImg = dataDescription!["ppimageUrl"] as? String ?? ""
                                    let firestorePost = ["imageUrl" : imgUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0, "userName" : userName, "ppImg" : ppImg] as [String : Any]
                                                               firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                                                   if error != nil {
                                                                       
                                                                       self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata!" )
                                                                   
                                                                   }else {
                                                                       
                                                                       self.imgView.image = UIImage(named: "yukle.jpg")
                                                                       self.commentText.text = ""
                                                                       self.tabBarController?.selectedIndex = 0
                                                                   }
                                                               })
                                }else{
                                    print("document boş")
                                }
                            }
                            
                           
                            
                        }
                    }
                    
                }
            }
        }
        
        
        
        
        
    }
    

}
