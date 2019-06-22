//
//  TimelineViewController.swift
//  fakestagram
//
//  Created by LuisE on 3/16/19.
//  Copyright © 2019 3zcurdia. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var postsCollectionView: UICollectionView!
    let client = TimelineClient()
    let refreshControl = UIRefreshControl()
    var pageOffset = 1
    var loadingPage = false
    var lastPage = false
    
    var posts: [Post] = [] {
        didSet { postsCollectionView.reloadData() }
    }
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.gray
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(didLikePost(_:)), name: .didLikePost, object: nil)
       
        refreshControl.addTarget(self, action: #selector(self.reloadData), for: UIControl.Event.valueChanged)
        
//        client.show { [weak self] data in
//            self?.posts = data
        
        loadingIndicator.center = self.view.center
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
        
        client.show { [weak self] data in
            self?.posts = data
            self?.loadingIndicator.stopAnimating()
            self?.postsCollectionView.reloadData()
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
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        postsCollectionView.prefetchDataSource = self
        let postCollectionViewCellXib = UINib(nibName: String(describing: PostCollectionViewCell.self), bundle: nil)
        postsCollectionView.register(postCollectionViewCellXib, forCellWithReuseIdentifier: PostCollectionViewCell.reuseIdentifier)
        postsCollectionView.addSubview(refreshControl)
    }
    
    @objc func reloadData() {
        pageOffset = 1
        client.show { [weak self] data in
            self?.posts = data
            sleep(1)
            self?.refreshControl.endRefreshing()
            self?.postsCollectionView.reloadData()
        }
    }

    @objc func didLikePost(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let row  = userInfo["row"] as? Int,
            let data = userInfo["post"] as? Data,
            let json = try? JSONDecoder().decode(Post.self, from: data) else { return }
        posts[row] = json
    }
    
    func loadNextPage(){
        if lastPage { return }
        loadingPage = true
        pageOffset += 1
        client.show(page: pageOffset) { [weak self ] posts in
            self?.lastPage = posts.count < 25
            self?.posts.append(contentsOf: posts)
            self?.loadingPage = false
            self?.postsCollectionView.reloadData()
        }
    }
}



extension TimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.postsCollectionView.frame.width, height: 600)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.post = posts[indexPath.row]
        cell.row = indexPath.row
        return cell
    }
}

extension TimelineViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if loadingPage { return }
        guard let indexPath = indexPaths.last else { return }
        let upperLimit = posts.count - 5
        if indexPath.row > upperLimit {
            loadNextPage()
        }
//        if indexPath.row > upperLimit {
//            loadingPage = true
//            DispatchQueue.global(qos: .background).async {
//                sleep(2)
//                self.loadingPage = false
//            }
//        }
    }
}

//extension TimelineViewController: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        if loadingPage { return }
//        guard let indexPath = indexPaths.last else { return }
//
//        if indexPath.row > posts.count - 5{
//            loadingPage = true
//            pageOffset += 1
//            client.show(page: pageOffset) { [week self] posts in
//                self?.posts.append(contentsOf: posts)
//                self?.loadingPage = false
//            }
//        }
//    }





//    func like() -> Post{
//        var post = self.post
//        guard let postId = post.id else { return post }
//        client.request("POST", path: "\(basePath)/\(postId)/like", body: nil, completionHandler: onSuccess(response: data:), errorHandler: onError(error:))
//        post.likesCount += 1
//        post.liked = true
//        return post
//    }
//
//    func dislike() -> Post{
//        var post = self.post
//        guard let postId = post.id else { return post }
//        client.request("DELETE", path: "\(basePath)/\(postId)/like", body: nil, completionHandler: onSuccess(response:data:), errorHandler: onError(error:))
//        post.likesCount -= 1
//        post.liked = false
//        return post
//    }
//
//    func onSuccess(response: HTTPResponse, data: Data?){
//        guard response.successful() else { return }
//        NotificationCenter.default.post(name: .didLikePost, object: nil, userInfo: ["PostID" : post.id as Any])
//        print("Yehi!!")
//    }
//
//    private func onError(error: Error?){
//        guard let err = error else { return }
//        print("Error on request: \(err.localizedDescription)")
//    }
//
//
//}
