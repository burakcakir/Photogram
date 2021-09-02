//
//  ViewController.swift
//  Photogram
//
//  Created by burak on 4.06.2021.
//  Copyright © 2021 burak. All rights reserved.
//

import UIKit // arayüz oluşturmaya yardımcı ios kütüphanesi 
import Firebase

class ViewController: UIViewController { // giriş yap , kayıt ol ekranı

   
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    @IBAction func girisYap(_ sender: Any) { // kullanıcı kayıtlıysa bilgilerini girip giriş yapması
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata!")
                }else {
                    self.performSegue(withIdentifier: "toTabBar", sender: nil) // bilgiler doğruysa ana sayfaya yönlendiriyor.

                }
            }
            
        }else {
            makeAlert(titleInput: "Hata!", messageInput: "Email/Şifre ?")
        }
        
    }
    
    @IBAction func kayitOl(_ sender: Any) { // kayıtlı olmayan kullanıcılar için kayıt olma fonksiyonu
        
        
        if emailText.text != "" && passwordText.text != ""{
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata!")
                }else{
                    let firestoreDatabase = Firestore.firestore()
                    var firestoreReference : DocumentReference? = nil
                    let firestorePost = ["ppimageUrl" : "https://firebasestorage.googleapis.com/v0/b/photogram-cd3e7.appspot.com/o/ppmedia%2Fpp.png?alt=media&token=4baee614-d338-4e39-a895-3c9b17fba59b"] as [String : Any]
                    firestoreDatabase.collection("ppmedia").document(Auth.auth().currentUser!.email!).setData(firestorePost, merge: true) // kullanıcının bilgilerini firabasede listeye atıyor.
                                                        
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
            
        }else{
                makeAlert(titleInput: "Hata!", messageInput: "Email/Şifre ?")
            }
            
        
        }
        
    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)

        let  okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true, completion: nil)
    }
        
        
    }
    
    
    


