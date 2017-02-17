//
//  JsonTableViewController.swift
//  TableJsonData
//
//  Created by Karumba Samuel on 13/02/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class JsonTableViewController: UITableViewController {
    var jsonData  = [Countries]()
    
    struct Countries {
        var name = ""
        var code = ""
        
        init(_ name:String, _ code:String){
            self.name = name
            self.code = code
        }
        
        
        
    }
    
    func getDataFromOnlineSource(_ link:String) {
        let url: URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            self.extractData(data)
            
        })
        
        task.resume()
    }
    
    func extractData(_ data:Data?) {
        let json:Any?
        
        if data == nil {
            return
        }
        
        do {
            json = try JSONSerialization.jsonObject(with: data!, options: [])

        }
        catch{
            return
        }
        
        guard let dataArray = json as? NSArray
        else {
            return
        }
        
        for i in 0 ..< dataArray.count {
            if let dataObject = dataArray[i] as? NSDictionary{
                if let objCountry = dataObject["country"] as? String,
                    let objCode = dataObject["code"] as? String{
                    
                    jsonData.append(Countries(objCountry,objCode))
                }
                
            }
        }
        
        refreshData()
        
    }
    
    func refreshData() {
        DispatchQueue.main.async(
            execute:{
                
                self.tableView.reloadData()
        
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let country1 = Countries("Kenya", "254")
//        jsonData.append(country1)
//        let country2 = Countries("Tanzania", "255")
//        jsonData.append(country2)
//        let country3 = Countries("Uganda", "256")
//        jsonData.append(country3)

        getDataFromOnlineSource("http://www.kaleidosblog.com/tutorial/tutorial.json")
        

    
    }

       // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jsonData.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let country = jsonData[indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.code


        return cell
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
