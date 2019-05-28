//
//  Helper.swift
//  NYTimesTop10
//
//  Created by Shubham Mishra on 28/05/19.
//  Copyright © 2019 Shubham Mishra. All rights reserved.
//

import Foundation
import Alamofire

let nytApiKey = "knEN0tpwvG8WjQ42H4zllKW1xPQ6HHCi"
let noInternetMessage = "No Internet Connection"
let somethingWentWrongMessage = "Something Went Wrong"
let unauthorizedMessage = "Not Authorized"
let requestLimitExidedMessage = "Sorry, You have exceded request limit"
let imageType = "mediumThreeByTwo210"


//func getNYTApiRequest() -> NSMutableURLRequest{
//    let url : String = "http://google.com?test=toto&test2=titi"
//    let request : NSMutableURLRequest = NSMutableURLRequest()
//    request.url = NSURL(string: url)! as URL
//    request.httpMethod = "GET"
//    return request
//}

func getRequestUrl(_ section: String) -> String{
    var mainUrl = nytRoute
    mainUrl.append("\(section).json")
    mainUrl.append("?api-key=\(nytApiKey)")
    return mainUrl
}

func getManagerWithConf() -> SessionManager
{
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForResource = 25.0
    configuration.timeoutIntervalForRequest = 25.0
    let manager = Alamofire.SessionManager(configuration: configuration)
    manager.session.configuration.timeoutIntervalForRequest = 25.0
    manager.session.configuration.timeoutIntervalForResource = 25.0
    return manager
    
}

