//
//  StripViewController1.swift
//  TechNews
//
//  Created by Felix on 2018/10/19.
//  Copyright © 2018 Felix. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SwiftyJSON
import RealmSwift
import SafariServices

class StripViewController1: UITableViewController, IndicatorInfoProvider, SFSafariViewControllerDelegate {
    
    let baseUrl = "https://hacker-news.firebaseio.com/v0/"
    let itemUrl = "https://hacker-news.firebaseio.com/v0/item/"
    //let hotEntryUrl = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fnews.ycombinator.com%2Frss"
    //let hotEntryUrl1 = "https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://b.hatena.ne.jp/hotentry/it.rss&num=100"
    enum Types : String {
        case new = "newstories.json"
        case top = "topstories.json"
        case ask = "askstories.json"
        case job = "jobstories.json"
    }
    enum Strips : String {
        case new = "Latest", top = "Top", ask = "Ask", job = "Jobs"
    }
    
    public var suffixUrl : Types = .top
    public var stripName : Strips = .top

    var entries : [Entry]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
        guard let realm = try? Realm() else {
            print("Realm initiate error")
            return
        }
        // get HackNews hotentries
        Alamofire.request(self.baseUrl + suffixUrl.rawValue).responseJSON { (response) in
            guard response.result.isSuccess, let value = response.result.value else {
                print("request wrong")
                return
            }
            let json = JSON(value)
            //print(json)
            for (index , itemId) : (String, JSON) in json {
                if (atoi(index) > 100) {
                    break
                }
                Alamofire.request(self.itemUrl + itemId.description + ".json").responseJSON { (response) in
                    guard response.result.isSuccess, let value = response.result.value else {
                        print("request wrong")
                        return
                    }
                    let json1 = JSON(value)
                    //print(json1.description)
                    if let entry = Mapper<Entry>().map(JSONString: json1.description) {
                        entry.customid = self.stripName.rawValue + String(entry.id)
                        realm.beginWrite()
                        realm.add(entry, update: true)
                        do {
                            try realm.commitWrite()
                        } catch { }
                        self.updateTableView()
                    }
                }
            }
            
        }
    //    Alamofire.request(hotEntryUrl).responseJSON { (response) in
    //        guard response.result.isSuccess, let value = response.result.value else {
    //            NSLog("Something Wrong")
    //            // FIXME:you need to handle errors.
    //            return
    //        }
    //        // write request result to realm database
    //        let json = JSON(value)
    //        //print(json.description)
    //        let entries = json["items"]
    //        realm.beginWrite()
    //        for (_, subJson) : (String, JSON) in entries {
    //            let entry = Mapper<Entry>().map(JSONString: subJson.description)!
    //            //let entry = Entry(JSON: subJson.dictionary!)!
    //            realm.add(entry, update: true)
    //        }
    //
    //        do {
    //            try realm.commitWrite()
    //        } catch {
    //
    //        }
    //        self.updateTableView()
    //    }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func updateTableView() {
        do {
            self.entries = try Realm().objects(Entry.self).filter("customid BEGINSWITH %@", self.stripName.rawValue).sorted(by: { (entry1, entry2) -> Bool in
                let res = entry1.time!.compare(entry2.time!)
                return (res == .orderedDescending || res == .orderedSame)
            })
        }catch {}
        if let entries = self.entries {
            if (entries.count > 100) {
                self.entries = [Entry](entries[0..<100])
            }
        }
        //print("Entries Number: ", entries!.count)
        tableView.reloadData()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.stripName.rawValue)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let entries = entries {
            return entries.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! EntryTableViewCell
        
        // if entries have been nil,"cellForRowAtIndexPath:indexPath:" isn't called.
        let entry = entries![indexPath.row]
        
        cell.title.text = entry.title
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        df.locale = Locale.current
        cell.timelabel.text = df.string(from: entry.time!) + "   by " + entry.author
        
        return cell
    }

    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 80.0
    //    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entries![indexPath.row]
        var url1 = entry.url
        if url1 == "" {
            url1 = "https://news.ycombinator.com/item?id=" + String(entry.id)
        }
        if let url = URL(string: url1) {
            //UIApplication.shared.open(link)
            let webViewController = SFSafariViewController(url: url)
            webViewController.delegate = self
            present(webViewController, animated: true, completion: nil)
        }
    }

    // MARK: SFSafariViewControllerDelegate

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
