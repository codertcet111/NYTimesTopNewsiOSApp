//
//  ViewController.swift
//  NYTimesTop10
//
//  Created by Shubham Mishra on 28/05/19.
//  Copyright © 2019 Shubham Mishra. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {

    var alamoFireManager = Alamofire.SessionManager.default
    var model: TopNewsResults?
    
    @IBOutlet weak var newsTableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildDataSource()
    }
    
    func buildDataSource(){
        self.alamoFireManager = getManagerWithConf()
        self.alamoFireManager.request(getRequestUrl("home"))
            .responseJSON { response in
                if( response.error != nil)
                {
                    return
                }
                guard response.result.error == nil else {
                    
                    if( response.result.error?._code == -999 )
                    {
                        return
                    }
                    
                    let alert = UIAlertController(title: noInternetMessage , message: nil , preferredStyle: UIAlertController.Style.alert)
                    self.present(alert, animated: true, completion:{   })
                    return
                }
                
                if(response.response != nil && response.data != nil){
                    switch  response.response?.statusCode {
                    case 200:
                        self.model = try? JSONDecoder().decode(TopNewsResults.self,from: response.data!)
                        self.newsTableViewOutlet.reloadData()
                    case 401:
                        self.showAlert(unauthorizedMessage)
                    case 429:
                        self.showAlert(requestLimitExidedMessage)
                    default:
                        self.showAlert(somethingWentWrongMessage)
                    }
                }
                
        }
    }
    
    func showAlert(_ message: String) -> (){
        let alert = UIAlertController(title: message, message: nil , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.num_results ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsTableViewCell
        if let tempNews = self.model?.results[indexPath.row]{
            cell.newsTitle.text = tempNews.title
            cell.newsTitle.numberOfLines = 3
            cell.newsTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
            let font = UIFont(name: "Helvetica", size: 20.0)
            cell.newsTitle.font = font
            cell.newsTitle.sizeToFit()
            
            let imageURL = URL(string: tempNews.multimedia[3].url)!
            cell.newsImage.sd_setShowActivityIndicatorView(true)
            cell.newsImage.sd_setIndicatorStyle(.gray)
            cell.newsImage.sd_setImage(with: imageURL)
            
            cell.newsDescription.text = tempNews.title
            cell.newsDescription.numberOfLines = 10
            cell.newsDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
            let temp_font = UIFont(name: "Helvetica", size: 15.0)
            cell.newsDescription.font = temp_font
            cell.newsDescription.sizeToFit()
            
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 0.0
//    }
    
}

