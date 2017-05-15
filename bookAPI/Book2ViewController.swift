//
//  Book2ViewController.swift
//  bookAPI
//
//  Created by Dana Goldberg on 4/13/17.
//  Copyright © 2017 Dana Goldberg. All rights reserved.
//

import UIKit

class Book2ViewController: UIViewController {
    
  
    @IBOutlet weak var secondImageView: UIImageView!
  
    
    @IBOutlet weak var secondTitleLabel: UILabel!
   
    @IBOutlet weak var secondSubtitle: UILabel!
    
    
    
    @IBOutlet weak var PageCount: UILabel!
    
    
    
    @IBOutlet weak var textSnippet: UILabel!
    
    
    var url: String?
    var myTitle: String?
    var mySubtitle:String?
    var myPageCount: Int?
    var myTextSnippet: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       secondImageView.imageFromUrl(urlString: url!)
       secondTitleLabel.text = myTitle
       secondSubtitle.text = mySubtitle
       PageCount.text = "\(myPageCount)"
        textSnippet.text = myTextSnippet
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBTNpressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
