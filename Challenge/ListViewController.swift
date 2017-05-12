//
//  ViewController.swift
//  Challenge
//
//  Created by Renan on 09/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ListViewController: UIViewController {
    
    var list: Variable<[Post]> = Variable([])
    let disposeBag = DisposeBag()
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Post().getPostsFromServer(completion: { (l, error) in
            if error != nil {
                print(error!)
                self.handleError(error: "There was an error while parsing your data")
            } else {
                self.list.value = l!
            }
        })
        
        tableView.delegate = self
        setupListCell()
    }

    func setupListCell() {
        list.asObservable().observeOn(MainScheduler.instance)
            .bindTo(tableView
                .rx //2
                .items(cellIdentifier: ListCell.Identifier,
                       cellType: ListCell.self)) { // 3
                        row, l, cell in
                        cell.configureCellWithData(list: l) //4
            }
            .addDisposableTo(disposeBag)
        
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        let l = list.value[tableView.indexPathForSelectedRow!.row]
        tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        destination.postId = l.id
        destination.userId = l.userId
     }
     

    
    
}


//MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fakeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let l = list.value[indexPath.row]
        fakeLabel.text = l.title
        let requiredTitle = fakeLabel.requiredHeight
        fakeLabel.text = l.body
        let requiredBody = fakeLabel.requiredHeight
        return requiredTitle + requiredBody + 43
        
    }
}
