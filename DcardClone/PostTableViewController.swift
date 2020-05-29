//
//  PostTableViewController.swift
//  DcardClone
//
//  Created by Jodie Hu on 2020/5/9.
//  Copyright © 2020 jodiehu. All rights reserved.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPostData()
        
    }

    //取得 API 資料
    func getPostData(){
        let postApiAdress = "https://www.dcard.tw/_api/posts"
        if let url = URL(string: postApiAdress){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let loadData = data{
                    //用 JSONDecoder 解析 API 自訂型別為 Post (Struct)，由於是 Array 所以加上中括號 [Post]
                    let decoder = JSONDecoder()
                    do {
                        let postsContent = try decoder.decode([Post].self, from: data!)
                        self.posts = postsContent
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                    
                }
            }.resume()
        }
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        if post.gender == "M"{
            cell.genderIcon.image = UIImage(named: "boy")
        }else if post.gender == "F"{
            cell.genderIcon.image = UIImage(named: "girl")
        }
        
        if post.school == nil {
            cell.schoolLabel.text = "匿名"
        }else{
            cell.schoolLabel.text = post.school
        }
        
        cell.forumNameLabel.text = post.forumName + " | "
        cell.titleLabel.text = post.title
        cell.excerptLabel.text = post.excerpt
        cell.likeCountLabel.text = "\(post.likeCount)"
        cell.commentCountLabel.text = "\(post.commentCount)"
        
        if post.likeCount == 0{
            cell.likeIcon.tintColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        }else{
            cell.likeIcon.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
        if post.mediaMeta.count != 0{
            let imageUrl = post.mediaMeta[0].url
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if error != nil{
                    print(error)
                }else{
                    if let imageData = data{
                        DispatchQueue.main.sync {
                            cell.postImage.isHidden = false
                            cell.postImage.image = UIImage(data: imageData)
                            cell.postImage.contentMode = .scaleAspectFill
                            cell.postImage.layer.cornerRadius = 10
                        }
                    }
                }
            }.resume()
        }else{
            cell.postImage.isHidden = true
        }
        
        return cell
    }
    
    //傳資料到下一頁
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let row = self.tableView.indexPathForSelectedRow?.row{
            if let controller = segue.destination as? PostDetailViewController{
                let post = posts[row]
                controller.post = post
            }
        }
    }
    

}
