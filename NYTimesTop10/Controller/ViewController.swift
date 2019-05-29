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

    //Have used the Alamofire for API's request and response handling
    var alamoFireManager = Alamofire.SessionManager.default
    var model: TopNewsResults?
    var activityView: UIActivityIndicatorView?
    
    @IBOutlet weak var newsTableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTableViewOutlet.separatorColor = UIColor.black
        //BuildDataSource will call the NYT's server and will set the table view
        self.buildDataSource()
        self.newsTableViewOutlet.estimatedRowHeight = self.newsTableViewOutlet.rowHeight
        self.newsTableViewOutlet.rowHeight = UITableView.automaticDimension
    }
    
    func buildDataSource(){
        self.showActivityIndicator()
        self.alamoFireManager = getManagerWithConf()
        //Below requesting to NYT's for section: home
        self.alamoFireManager.request(getRequestUrl("home"))
            .responseJSON { response in
                self.stopActivityIndicator()
                if( response.error != nil)
                {
                    self.showAlert(somethingWentWrongMessage)
                    return
                }
                guard response.result.error == nil else {
                    
                    if( response.result.error?._code == -999 )
                    {
                        self.showAlert(somethingWentWrongMessage)
                        return
                    }
                    
                    self.showAlert(noInternetMessage)
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
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { _ in
           self.buildDataSource()
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            self.newsTableViewOutlet.isHidden = true
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator(){
        self.activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView?.center = self.view.center
        activityView?.hidesWhenStopped = true
        activityView?.startAnimating()
        activityView?.color = UIColor.black
        self.view.addSubview(activityView!)
    }
    
    func stopActivityIndicator(){
        self.activityView?.stopAnimating()
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
            if tempNews.multimedia.count >= 4{
                let imageURL = URL(string: tempNews.multimedia[3].url)!
                cell.newsImage.sd_setShowActivityIndicatorView(true)
                cell.newsImage.sd_setIndicatorStyle(.gray)
                cell.newsImage.contentMode = UIView.ContentMode.scaleAspectFit
                cell.newsImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named:"NYTimesPlaceholder.jpeg"))
            }
            cell.newsDescription.text = tempNews.abstract
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = self.model?.results[indexPath.row].url, #available(iOS 10, *){
            UIApplication.shared.open(URL(string: url)!, options: [:])
        }
    }
    
}

