//
//  ViewController.swift
//  bookAPI
//
//  Created by Dana Goldberg on 4/11/17.
//  Copyright © 2017 Dana Goldberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var secondSegmentedControl: UISegmentedControl!
    

    @IBOutlet weak var scrollButton: UIButton!
  
    
    
    var books = [Book] ()
    var cell: UITableViewCell?
  
    var orderBy = "newest"
    var printType = "all"
    var text = ""
    var startIndex = 0
    var maxResults = 10
    var loadMore = false
    
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        self.scrollButton.isHidden = true
               // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    @IBAction func scrollButton(_ sender: Any) {
         scrollToTop()
         self.scrollButton.isHidden = true
    }

    @IBAction func segmentedControltapped(_ sender: Any) {
        
        switch(mySegmentedControl.selectedSegmentIndex){
            
        case 0:
            orderBy = "newest"
            getBooks(query: text)
        case 1:
            orderBy = "relevance"
            getBooks(query: text)
        default:
            return
            
        }
 
        
    }
    
    @IBAction func mySCDSegmentedCtapped(_ sender: Any) {
        
        switch(secondSegmentedControl.selectedSegmentIndex){
            
        case 0:
            printType = "all"
            getBooks(query: text)
        case 1:
            printType = "books"
            getBooks(query: text)
            
        case 2:
            printType = "magazines"
            getBooks(query: text)
            
        default:
            return
            
        }
        

        
    }
    
    
    func getBooks (query : String) {
    
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://www.googleapis.com/books/v1/volumes?q=\(query)&orderBy=\(orderBy)&printType=\(printType)&startIndex=\(startIndex)&maxResults=10"
        
        
     URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
      if (error != nil)  {
        print(error?.localizedDescription as Any)
        }else {
              
        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
        
         if let items = json["items"] as? [[String:AnyObject]]{
         print("got items",items)
            
            self.books = [Book] ()
  
            for item in items {
             if let volumeInfo = item ["volumeInfo"] as? [String:AnyObject] {
              let book = Book ()
                book.title = volumeInfo ["title"] as? String
                
                
                if let authors = volumeInfo ["authors"] as? [String] {
                 book.authors = ""
                   
                    for (index,name) in authors.enumerated() {
                        
                        if authors.count - 1 == index{
                            
                            book.authors = book.authors! + name + " . "

                        } else {
                            
                            book.authors = book.authors! + name + " , "
 
                        }
                        
                    }
                }
                
                if let imageLinks = volumeInfo ["imageLinks"] as? [String:String] {
                 book.imageURL = imageLinks["thumbnail"]
                }
                if let subtitle = volumeInfo ["subtitle"] as? String {
                     book.subtitle = subtitle
                    print("hello\(subtitle)")
                    
                }
                if let searchInfo = item ["searchInfo"] as? [String: AnyObject] {
                    print(searchInfo)
                    if let textSnippet = searchInfo["textSnippet"] as? String{
                        book.textSnippet = textSnippet
                        print(textSnippet)
                    }
                }
                if let pageCount = volumeInfo ["pageCount"] as? Int{
                    book.pageCount = pageCount
                    print("myPageCount\(pageCount)")
                }
                
                
                   self.books.append(book)
                }
            }
          
            DispatchQueue.main.async {
            self.tableView.reloadData()
            }
           }
    }
    
    }.resume()
}
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookvc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! Book2ViewController
        bookvc.url = self.books[indexPath.row].imageURL
        bookvc.myTitle = self.books[indexPath.row].title
        bookvc.mySubtitle = self.books[indexPath.row].subtitle
        bookvc.myPageCount = self.books[indexPath.row].pageCount
        bookvc.myTextSnippet = self.books[indexPath.row].textSnippet
        
        self.present(bookvc, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookItemTableViewCell
        // customizing cell
        
        
             cell.titleLabel.text = books [indexPath.row].title!
        
        if books[indexPath.row].imageURL != nil {
            cell.coverImageView.imageFromUrl(urlString: books[indexPath.row].imageURL!)
        }
        
     
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 1 {
            self.startIndex = startIndex + 10
            self.scrollButton.isHidden = false
            
   
            getBooks(query: text)
           
        }
    }
    func scrollToTop (){
        let indexPath = NSIndexPath(row: 0, section: 0)
   
        self.tableView.scrollToRow(at: indexPath as IndexPath,
                                   at: UITableViewScrollPosition.top, animated:true)
    }
}



// continue


extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.text = searchBar.text!
        print(text)
        self.getBooks(query: text)
    }
    
    
    }
  extension UIImageView {
    
    public func imageFromUrl(urlString:String) {
        
        if let url = URL (string: urlString){
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if (error != nil) {
                print (error?.localizedDescription as Any)
            }else {
                if let image = UIImage(data: data!){
                    DispatchQueue.main.async {
                        self.image = image
                    }
                
                }
            }
            
        }).resume()
        }
    }
    }


