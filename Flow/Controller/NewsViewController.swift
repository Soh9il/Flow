//
//  NewsViewController.swift
//  Flow
//
//  Created by Soheil Sharafzadeh on 03/09/2021.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var File1: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func file1ButtonTouchUpInside(_ sender: Any) {
        NewsAPI.shared.concurrentSearchRequest(keyword1: "Apple", keyword2: "Google", keyword3: "Facebook") { articles in
            print("Articles: \(articles)")
        }
    }
        
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
