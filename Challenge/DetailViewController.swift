//
//  DetailViewController.swift
//  Challenge
//
//  Created by Renan on 10/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

    var postId: Int = 0
    var userId: Int = 0
    
    var comments: Variable<[Comments]> = Variable([])
    var user: Variable<User> = Variable(User())
    
    @IBOutlet var commentsTableView: UITableView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var numberOfComments: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        commentsTableView.delegate = self
        Comments().getCommentsFromServer(postId: postId) { (c, error) in
            print(c!)
            if error == nil {
                self.comments.value = c!
            } else {
                self.handleError(error: "There was an error while parsing the comments")
                print(error!)
            }
        }
        
        User().getUserInfoFromServer(userId: userId) { (u, error) in
            if error == nil {
                self.user.value = u!
            } else {
                self.handleError(error: "There was an error while parsing the user info")
                print(error!)
            }
        }
        
        setupCommentCell()
        setupLabels()
        commentsTableView.estimatedRowHeight = 100
    }
    
    
    func setupCommentCell() {
        comments.asObservable().observeOn(MainScheduler.instance)
            .bindTo(commentsTableView
                .rx //2
                .items(cellIdentifier: "Cell",
                       cellType: UITableViewCell.self)) {
                        row, c, cell in
                        cell.textLabel?.text = c.body
                        cell.textLabel?.numberOfLines = 0
                        cell.textLabel?.sizeToFit()
            }
            .addDisposableTo(disposeBag)
        
        
    }
    
    
    func setupLabels() {
        user.asObservable()
            .observeOn(MainScheduler.instance)
            .map { (u) -> String in
                "Name: \(u.userName)"
            }
            .bindTo(authorLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        comments.asObservable()
            .observeOn(MainScheduler.instance)
            .map { (c) -> String in
                "Total of comments:" + String(c.count)
            }.bindTo(numberOfComments.rx.text)
        .addDisposableTo(disposeBag)
    }

}

//MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fakeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let l = comments.value[indexPath.row]
        fakeLabel.text = l.body
        return fakeLabel.requiredHeight + 30
    }
}
