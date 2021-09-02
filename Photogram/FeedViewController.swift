//
//  FeedViewController.swift
//  Photogram
//
//  Created by burak on 5.06.2021.
//  Copyright © 2021 burak. All rights reserved.
//

import UIKit // arayüz oluşturmaya yardımcı ios kütüphanesi
import Firebase
import SDWebImage  // vt den foto çekip bastırmaya yarar.

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { // ana sayfa

    


    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImgArray = [String]()
    var userPpArray = [String]()
    var documentIDArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        getDataFromFirestore()
       

    }
    
    
    func getDataFromFirestore() {
        	
        let fireStoreDatabase = Firestore.firestore()
    
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            }else {
                if snapshot?.isEmpty != true {
                    
                    
                    self.userImgArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    self.userPpArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("userName") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imgUrl = document.get("imageUrl") as? String {
                            self.userImgArray.append(imgUrl)
                        }
                        if let pp = document.get("ppImg") as? String {
                            self.userPpArray.append(pp)
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    
        
       
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userMailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImg.sd_setImage(with: URL(string: self.userImgArray[indexPath.row]))
        cell.ppImg.sd_setImage(with: URL(string: self.userPpArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArray[indexPath.row]
        return cell
    }

    
    
    
}
