//
//  ReaderViewController.swift
//  Flow
//
//  Created by Soheil Sharafzadeh on 03/09/2021.
//

import UIKit
import PDFKit

class ReaderViewController: UIViewController {

    private var pdfView : PDFView?


    override func viewDidLoad() {
        super.viewDidLoad()

        pdfView = PDFView(frame: self.view.bounds)
        pdfView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Fit content in PDFView.
        pdfView?.autoScales = true

        // Load Sample.pdf file from app bundle.
        let url = Bundle.main.url(forResource: "file2", withExtension: "pdf")
        pdfView?.document = PDFDocument(url: url!)
        
        self.view.addSubview(pdfView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pdfView?.goToFirstPage(nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.autoscroll()
    }
    func autoscroll() {
        let pageCount = (pdfView?.document?.pageCount)!
        var pageIndex = 0
        var y = 0
        let maxY = 72

        while pageIndex < pageCount-1 {
            y = 0
            while y < maxY  {
                y += 1
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                usleep(2000)
                    self.pdfView?.go(to:CGRect(x: 10, y: y, width: 100, height: 100), on:(self.pdfView?.document?.page(at: pageIndex))!)
//                }
            }
            pageIndex += 1
        }

    }
    
    func makeRequest() {
        let params = ["username":"john", "password":"123456"] as Dictionary<String, String>

        var request = URLRequest(url: URL(string: "http://localhost:8080/api/1/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })

        task.resume()
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
