//
//  PostDetailViewController.swift
//  DcardClone
//
//  Created by Jodie Hu on 2020/5/9.
//  Copyright © 2020 jodiehu. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    
    @IBOutlet weak var genderIcon: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var forumNameLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    
    var post:Post!
    var postDetail:PostDetail?

    override func viewDidLoad() {
        super.viewDidLoad()

        getPostDetailData()
        if post.gender == "M"{
            genderIcon.image = UIImage(named: "boy")
            genderLabel.text = "男同學"
        }else if post.gender == "F"{
            genderIcon.image = UIImage(named: "girl")
            genderLabel.text = "女同學"
        }
        if post.school == nil {
            schoolLabel.text = "匿名"
        }else{
            schoolLabel.text = post.school
        }
        forumNameLabel.text = post.forumName
        titleLabel.text = postDetail?.title
        
    }
    
    func getPostDetailData(){
        
        if let url = URL(string: "https://www.dcard.tw/_api/posts/\(post.id)"){
            //print(post.id)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                //用 JSONDecoder 解析 API
                let decoder = JSONDecoder()
                //用 ISO8601DateFormatter 解析時間
                let dateFormatter = ISO8601DateFormatter()
                //withInternetDateTime 標準的 ISO 8601 格式；withFractionalSeconds 包含小數的秒
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                
                decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                    //取得 createdAt 內容
                    let data = try decoder.singleValueContainer()
                    //取得 createdAt 字串
                    let dateString = try data.decode(String.self)
                    return dateFormatter.date(from: dateString) ?? Date()
                })
                
                if let loadData = data{
                    do{
                        let postsDetailContent = try decoder.decode(PostDetail.self, from: data!)
                        self.postDetail = postsDetailContent
                    }catch{
                        print(error)
                    }
                }
                
                
                let contentArray = self.postDetail?.content.split(separator: "\n").map(String.init)
                let mutableAttributedString = NSMutableAttributedString()
                contentArray?.forEach({ (row) in
                    if row.contains("http") {
                        mutableAttributedString.append(imageFrom: row, textView: self.contentLabel)
                    } else {
                        mutableAttributedString.append(string: row)
                    }
                })
                
                DispatchQueue.main.async {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/mm/dd hh:mm"
                    let timeText = formatter.string(from: self.postDetail!.createdAt)
                    self.createdTimeLabel.text = timeText
                    self.titleLabel.text = self.postDetail?.title
                    self.contentLabel.attributedText = mutableAttributedString
                }
            }.resume()
        }
    }
    

}
extension NSMutableAttributedString{
    func append(string:String){
        self.append(NSAttributedString(string: string + "\n", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
    }
    
    func append(imageFrom: String, textView: UITextView) {
        guard let url = URL(string: imageFrom) else { return }
        
        UIImage.image(from: url) { (image) in
            guard let image = image else { return }
            let scaledImg = image.scaled(with: UIScreen.main.bounds.width / image.size.width * 0.8)
            let attachment = NSTextAttachment()
            attachment.image = scaledImg
            self.append(NSAttributedString(attachment: attachment))
            self.append(NSAttributedString(string: "\n"))
        }
    }
    
}

extension UIImage{
    static func image(from url: URL, handel: @escaping (UIImage?) -> ()) {
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else{
            handel(nil)
            return
        }
        handel(image)
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
        let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
