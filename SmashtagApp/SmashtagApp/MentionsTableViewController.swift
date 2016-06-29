//
//  MentionsTableViewController.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import UIKit
import SafariServices

protocol SearchTextDataSource: class {
    func setTextOfSearchBar(text: String)
}

class MentionsTableViewController: UIViewController, SFSafariViewControllerDelegate {

    private let tableView = UITableView()
    var tweet: Tweet? {
        didSet {
            mentions.removeAll()

            if let user = tweet?.user.name {
                title = "\(user)"
            }
            if let imageMention = tweet?.media {
                if imageMention.count > 0 {
                    let imageMentionArray = Mentions(title: "image", data: imageMention.map { (MentionItem.Image($0.url)) })
                    mentions.append(imageMentionArray)
                }
            }
            if var urlMention = tweet?.urls {
                if urlMention.count > 0 {
                    let urlArray = Mentions(title: "url", data: urlMention.map { _ in
                        return MentionItem.Keyword(urlMention.removeLast())})
                    mentions.append(urlArray)
                }
            }
            if var hashTagMention = tweet?.hashtags {
                if hashTagMention.count > 0 {
                    let hashTagArray = Mentions(title: "hashtag", data: hashTagMention.map { _ in
                        return MentionItem.Keyword("#" + hashTagMention.removeLast()) })
                    mentions.append(hashTagArray)
                }
            }
            if let userScreenName = tweet?.user.screenName {
                var userArray = Mentions(title: "username", data: [MentionItem.Keyword("@\(userScreenName)")])
                if var userMention = tweet?.userMentions {
                    if userMention.count > 0 {
                        var userMentionArray = [MentionItem]()
                        userMentionArray.append(MentionItem.Keyword("@" + userMention.removeLast()))
                        userArray.data.appendContentsOf(userMentionArray)
                    }
                }
                mentions.append(userArray)
            }
            tableView.reloadData()
        }
    }

    private var mentions = [Mentions]()
    weak var dataSource: SearchTextDataSource?

    private struct Mentions {
        var title: String
        var data: [MentionItem] = []
    }

    private enum MentionItem {
        case Image(NSURL)
        case Keyword(String)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        addTableView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Mention")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func addTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 59/255, green: 63/255, blue: 64/255, alpha: 1)
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    }
}

extension MentionsTableViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Mention", forIndexPath: indexPath)
        cell.backgroundColor = UIColor(red: 59/255, green: 63/255, blue: 64/255, alpha: 1)
        cell.textLabel?.textColor = .whiteColor()
        cell.selectionStyle = .None
        switch mention {
        case .Image(let url) :
            let imageData = NSData(contentsOfURL: url)
            cell.imageView?.image = UIImage(data: imageData!)
            return cell
        case .Keyword(let keyword):
            cell.textLabel?.text = keyword
            return cell
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
}

extension MentionsTableViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_):
            return tableView.bounds.size.width
        case .Keyword(_):
            return UITableViewAutomaticDimension
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Keyword(let keyword):
            let mentionTitle = mentions[indexPath.section].title
            if mentionTitle == "url" {
                let url = NSURL(string: keyword)
                let webPage = SFSafariViewController(URL: url!, entersReaderIfAvailable: true)
                presentViewController(webPage, animated: true, completion: nil)
            }
            else {
                dataSource?.setTextOfSearchBar(keyword)
                navigationController?.popViewControllerAnimated(true)
            }
        case .Image(_):
            let imageViewController = ImageViewController()
            let mention = mentions[indexPath.section].data[indexPath.row]
            switch mention {
            case .Image(let url):
                imageViewController.imageUrl = url
            default: break
            }
            navigationController?.pushViewController(imageViewController, animated: true)
        }
    }
}
