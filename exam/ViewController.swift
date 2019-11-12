//
//  ViewController.swift
//  exam
//
//  Created by D7702_09 on 2019. 11. 12..
//  Copyright © 2019년 csd5766. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    var contents = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mTableView.delegate = self
        mTableView.dataSource = self
        
        self.title = "Busan Map Tour"
        
        // 데이터 로드
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        contents = NSArray(contentsOfFile: path!)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = mTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        let myTitle = (contents[indexPath.row] as AnyObject).value(forKey: "title")
        let myAddress = (contents[indexPath.row] as AnyObject).value(forKey: "address")
        
        print(myAddress!)
        
        myCell.textLabel?.text = myTitle as? String
        myCell.detailTextLabel?.text = myAddress as? String
        
        return myCell
    }
    
    // 위치정보 등 데이터를 DetailMapViewController에 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            
            let detailMVC = segue.destination as! DetailMapViewController
            let selectedPath = mTableView.indexPathForSelectedRow
            
            let myIndexedTitle = (contents[(selectedPath?.row)!] as AnyObject).value(forKey: "title")
            let myIndexedAddress = (contents[(selectedPath?.row)!] as AnyObject).value(forKey: "address")
            
            print("myIndexedTitle = \(String(describing: myIndexedTitle))")
            
            detailMVC.dTitle = myIndexedTitle as? String
            detailMVC.dAddress = myIndexedAddress as? String
            
        } else if segue.identifier == "goTotalMap" {
            print("this is TotlMapViewController")
            
            let totalMVC = segue.destination as! TotalMapViewController
            totalMVC.dContents = contents
            
        }
    }


}

