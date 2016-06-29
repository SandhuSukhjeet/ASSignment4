//
//  TweetTableViewController.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import UIKit

class TweetTableViewController: UIViewController {

    private let mentionsViewController = MentionsTableViewController()
    private let tableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.estimatedRowHeight = 200  // Max height for cell
        $0.rowHeight = UITableViewAutomaticDimension
        return $0
    }(UITableView())

    private let refreshControl: UIRefreshControl = {
        $0.tintColor = .lightGrayColor()
        return $0
    }(UIRefreshControl())

    private var tweets = [[Tweet]]()
    private var searchBar = UISearchBar()
    private var searchText: String? = "#stanford" {
        didSet {
            searchBar.text = searchText
            refresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        self.navigationItem.titleView = searchBar
        searchBar.barStyle = UIBarStyle.Default
        searchBar.text = searchText
        addTableView()
        addRefreshControl()
        tableView.delegate = self
        tableView.dataSource = self
        mentionsViewController.dataSource = self
        searchBar.delegate = self
        tableView.registerClass(TweetTableViewCell.self, forCellReuseIdentifier: "Tweet")
        refresh()
    }

    private func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }

    private func addTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 59/255, green: 63/255, blue: 64/255, alpha: 1)
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
         view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    }

    func refresh() {
        tweets.removeAll()
        refreshControl.beginRefreshing()
        tableView.reloadData()
        if searchText != nil {
            let request = TwitterRequest(search: searchBar.text!, count: 100)
            request.fetchTweets  { (newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0 {
                        self.tweets.insert(newTweets, atIndex: 0)
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
        else {
            refreshControl.endRefreshing()
        }
    }
}

extension TweetTableViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Tweet", forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
}

extension TweetTableViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        mentionsViewController.tweet = tweets[indexPath.section][indexPath.row]
        navigationController?.pushViewController(mentionsViewController, animated: true)
    }
}

extension TweetTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        refresh()
    }
}

extension TweetTableViewController: SearchTextDataSource {

    func setTextOfSearchBar(text: String) {
        searchText = text
    }
}
