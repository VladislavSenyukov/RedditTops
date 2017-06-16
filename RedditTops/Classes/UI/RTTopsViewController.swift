//
//  RTTopsViewController.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 13.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTTopsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let topsDatasource = RTTopsDatasource()
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        if topsDatasource.count == 0 {
            loadTops()
        }
    }
    
    func loadTops() {
        spinner?.startAnimating()
        topsDatasource.load {[unowned self] (indices, error) in
            self.spinner?.stopAnimating()
            if error == nil {
                self.tableView?.beginUpdates()
                self.tableView?.insertRows(at: indices, with: .none)
                self.tableView?.endUpdates()
            } else {
                // TODO: show alert error
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topsDatasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RTItemTableViewCell.identifier, for: indexPath)
        if let itemCell = cell as? RTItemTableViewCell {
            let item = topsDatasource[indexPath.row]
            itemCell.updateWithItem(item: item)
            itemCell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if topsDatasource.shouldLoadNextPage(indexPath: indexPath) {
            loadTops()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let url = sender as? String,
            let vc = segue.destination as? RTImagePreviewViewController
        else {
            // TODO: show error no preview
            return
        }
        vc.url = url
    }
}

extension RTTopsViewController : RTItemTableViewCellDelegate {
    func itemTableCell(cell: RTItemTableViewCell, didTapOnItem item: RTItem) {
        performSegue(withIdentifier: "ShowPreview", sender: item.originalPreview?.url)
    }
}
