//
//  ImageViewController.swift
//  SmashtagApp
//
//  Created by sukhjeet singh sandhu on 23/06/16.
//  Copyright © 2016 sukhjeet singh sandhu. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageUrl: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }

    private var imageView = UIImageView()
    private var scrollView:UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.minimumZoomScale = 0.03
        $0.maximumZoomScale = 2.0
        return $0
    }(UIScrollView())
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
        addScrollView()
        scrollView.addSubview(imageView)
    }

    private func addScrollView() {
        view.addSubview(scrollView)
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    }

    private func fetchImage() {
        if let url = imageUrl {
            if let imageData = NSData(contentsOfURL: url) {
                image = UIImage(data: imageData)
            }
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
