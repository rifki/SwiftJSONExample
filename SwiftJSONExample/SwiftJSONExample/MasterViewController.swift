//
//  MasterViewController.swift
//  SwiftJSONExample
//
//  Created by rifki on 9/17/14.
//  Copyright (c) 2014 rifkilabs. All rights reserved.
//

import UIKit

let apiURL      = "http://api.ihackernews.com/page"
let diffQueue   = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
let mainQueue   = dispatch_get_main_queue()

class MasterViewController: UITableViewController {

    var data = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJSON()
    }
    
    func getJSON() {
        let request = NSURLRequest(URL: NSURL(string: apiURL ) )
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            dispatch_async(diffQueue) {
                var error: NSError?
                self.data = (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary)["items"] as NSMutableArray
                
                //for dic in self.data {}
                
                dispatch_async(mainQueue) {
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let getTitle        = (data[indexPath.row]["title"] as String)
        let getPostedAgo    = (data[indexPath.row]["postedAgo"] as String)
        let getPostedBy     = (data[indexPath.row]["postedBy"] as String)
        let getCommentCount = (data[indexPath.row]["commentCount"] as Int)
        
        cell.textLabel?.text = getTitle
        cell.detailTextLabel?.text = "\(getPostedAgo) By \(getPostedBy) Comment(\(getCommentCount))"
        
        
        return cell
    }

}

