//
//  ProfileViewController.swift
//  fakestagram
//
//  Created by LuisE on 4/23/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var peviewPostsCollectionView: UICollectionView!
    @IBOutlet weak var authorView: PostAuthorView!
    
    var posts = [Post]()
    let reuseIdentifier = "postThumbnailCell"
    
    let client = ProfilePostsClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        loadAuthor()
        
        client.show { [weak self] posts in
            self?.posts = posts
            self?.peviewPostsCollectionView.reloadData()
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func configCollectionView() {
        peviewPostsCollectionView.delegate = self
        peviewPostsCollectionView.dataSource = self
        let postThumbnailViewCellXib = UINib(nibName: String(describing: PostThumbnailCollectionViewCell.self), bundle: nil)
        peviewPostsCollectionView.register(postThumbnailViewCellXib, forCellWithReuseIdentifier: PostThumbnailCollectionViewCell.reuseIdentifier)
        
    }
    
    func loadAuthor() {
        
        guard let acc = AccountRepo.shared.load() else { return }
        authorView.author = acc.toAuthor()
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = peviewPostsCollectionView.frame.width / 3.0
        print(size)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostThumbnailCollectionViewCell
        let post = posts[indexPath.row]
//        print(post.title)
//        cell.backgroundColor = .red
        cell.post = post
        return cell

    }
    
    
}
