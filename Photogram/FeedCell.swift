//
//  FeedCell.swift
//  Photogram
//
//  Created by burak on 5.06.2021.
//  Copyright © 2021 burak. All rights reserved.
//

import UIKit	// arayüz oluşturmaya yardımcı ios kütüphanesi
import Firebase
	

class FeedCell: UITableViewCell { // postlar 

    
    @IBOutlet weak var userMailLabel: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var ppImg: UIImageView!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }



   
    @IBAction func likeButtonClick(_ sender: Any) { // postun beğenme kontrolü
      	
        
        let fireStoreDatabase = Firestore.firestore()
         ref = Database.database().reference()
        
        
        
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
                fireStoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            }
        
            self.ref.child("likes").child(documentIDLabel.text!).child(Auth.auth().currentUser!.uid).setValue(["like" : "true"])
        
            self.likeButton.isHidden = true
            self.unlikeButton.isHidden = false
        
    }
    
    @IBAction func unLikeClick(_ sender: Any) { // postun beğenmekten vazgeçme kontrolü
        let fireStoreDatabase = Firestore.firestore()
        ref = Database.database().reference()
        
            if let likeCount = Int(likeLabel.text!){
                      
                let likeStore = ["likes" : likeCount - 1] as [String : Any]
                fireStoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            }
               self.ref.child("likes").child(documentIDLabel.text!).child(Auth.auth().currentUser!.uid).removeValue()
                self.unlikeButton.isHidden = true
                self.likeButton.isHidden = false

            }
    }
    
   
    
    
    

