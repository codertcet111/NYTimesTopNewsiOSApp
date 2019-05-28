//
//  TopNewsResults.swift
//  NYTimesTop10
//
//  Created by Shubham Mishra on 28/05/19.
//  Copyright © 2019 Shubham Mishra. All rights reserved.
//

import Foundation

struct TopNewsResults: Codable{
    //Not receiving unncessary keys
    let status: String
    let copyright: String
    let section: String
    let num_results: Int
    let results: [IndivisualNews]
    
    struct IndivisualNews: Codable{
        //Not receiving unncessary keys
        let title: String
        let abstract: String
        let url: String
        let byline: String
        let multimedia: [Multimedia]
        
        struct Multimedia: Codable{
            //Not receiving unncessary keys
            let url: String
            let format: String
            let height: Float
            let width: Float
            let type: String
            let subtype: String
        }
    }
    
}
