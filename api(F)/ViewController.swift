//
//  ViewController.swift
//  api(F)
//
//  Created by undhad kaushik on 03/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var apiTabelView: UITableView!
    var arrMain: Main!
    var newArr: [Main] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nibRegister()
        apiE()
        
    }
    
    private func nibRegister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        apiTabelView.register(nibFile, forCellReuseIdentifier: "cell")
        apiTabelView.separatorStyle = .none
        apiTabelView.delegate = self
        apiTabelView.dataSource = self
        
        
    }
    
    private func apiE(){
        // https://api.coingecko.com/api/v3/exchange_rates
        AF.request("https://api.coingecko.com/api/v3/exchange_rates",method: .get).responseData{ [self] response in
           debugPrint(response)
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(Main.self, from: apiData)
                    print(result)
                    arrMain = result
                    newArr = [arrMain]
                    apiTabelView.reloadData()
                    
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("wrong")
            }
        }
        
        
    }


}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return arrMain?.rates.btc.name.count ?? 0
        
        return newArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell

        cell.label1.text = newArr[indexPath.row].rates.ltc.name
        cell.label2.text = newArr[indexPath.row].rates.btc.name
        cell.label3.text = newArr[indexPath.row].rates.eth.name
       
        return cell
    }
}

struct Main: Decodable{
    let rates: Rates
}

struct Rates: Decodable{
    var btc: One
    var eth: Two
    var ltc: Three
    enum CodingKeys: String, CodingKey{
        case btc , eth , ltc
    }
}

struct One: Decodable{
    var name: String
    var unit: String
    var value: Double
    var type: String
    
    enum CodingKeys: String, CodingKey{
        case name , unit , value , type
    }
}

struct Two: Decodable{
    var name: String
    var unit: String
    var value: Double
    var type: String
    enum CodingKeys: String, CodingKey{
        case name , unit , value , type
    }
}

struct Three: Decodable{
    var name: String
    var unit: String
    var value: Double
    var type: String
    enum CodingKeys: String, CodingKey{
        case name , unit , value , type
    }
}

