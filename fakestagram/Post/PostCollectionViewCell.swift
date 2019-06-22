//
//  PostCollectionViewCell.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "postViewCell"
    public var row: Int = -1
    public var post: Post? {
        didSet { updateView() }
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorView: PostAuthorView!
    @IBOutlet weak var titleLbl: UITextView!
    @IBOutlet weak var likesCountLbl: UILabel!
    @IBOutlet weak var commentsCountLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
 

    lazy var doubleTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapLike(_:)))
        gesture.numberOfTapsRequired = 2
        return gesture
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.addGestureRecognizer(doubleTapGesture)
        updateView()
    }

    private func reset() {
        imageView.image = nil
        titleLbl.text = nil
        likesCountLbl.text = nil
        commentsCountLbl.text = nil
    }
    
    private func updateView() {
        guard let post = self.post else { return }
        post.load { [weak self] img in
            self?.imageView.image = img
        }
        authorView.author = post.author
        titleLbl.text = "\(post.title)\n\(post.location)"
        likesCountLbl.text = "\(post.likesCount) likes"
        commentsCountLbl.text = "\(post.commentsCount) comments"
    }
    
    @objc func doubleTapLike(_ sender: Any) {
        updateLike()
    }
    
    @IBAction func tapLike(_ sender: Any) {
//        guard let post  = post else { return }
//        let client = LikeUpdaterClient (post: post, row: row)
//        self.post = client.call()
////        LikeUpdaterClient(post: post).call()
////        if post.swapliked() {
////            post.likesCount = client.like(post: post)
////
////        }
        updateLike()
    }
    
    private func updateLike() {
        guard let post = post else { return }
        let client = LikeUpdaterClient(post: post, row: row)
        self.post = client.call()
    }
}
