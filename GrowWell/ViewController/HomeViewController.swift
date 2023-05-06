//
//  HomeViewController.swift
//  GrowWell
//
//  Created by Guido william on 25/04/23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var lbWelcome: UILabel!
    
    @IBOutlet weak var lbPoint: UILabel!
    
    @IBOutlet weak var tvUsersPlant: UITableView!
    
    var context:NSManagedObjectContext!

    var rUser: NSManagedObject?
    
    var arrOfNames = [String]()
    var arrOfWaterLevel = [Double]()
    var arrOfHeight = [Double]()
    var arrOfImage = [String]()
    var arrOfMaxWater = [Double]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // data tiap cellnya dikasih apa
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UsersPlantTableViewCell
        cell.lbName.text = arrOfNames[indexPath.row]
        let urlString = arrOfImage[indexPath.row]
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else { return cell }
        cell.ivPlant.image = UIImage(data: data)
        let waterLevel = arrOfWaterLevel[indexPath.row]
        let maxLevel = arrOfMaxWater[indexPath.row]
        cell.pbWater.progress = Float((Double(waterLevel) / (Double(maxLevel)))*100)
        let height = arrOfHeight[indexPath.row]
            cell.tfHeight.text = String(height)
        cell.btnWater.addTarget(cell, action: #selector(UsersPlantTableViewCell.buttonTapped(_:)), for: .touchUpInside)
        cell.updateHandler = {
            self.updateData(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    func updateData(cell: UsersPlantTableViewCell, indexPath: IndexPath){
        guard let email = rUser?.value(forKey: "email") as? String else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersPlants")
        let predicate = NSPredicate(format: "email == %@ AND image == %@", email, arrOfImage[indexPath.row])
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for data in results {
                if let newHeight = Double(cell.tfHeight.text ?? "") {
                                data.setValue(newHeight, forKey: "height")
                            }
                let currentWaterLevel = data.value(forKey: "waterLevel") as? Double ?? 0
                let newWaterLevel = currentWaterLevel + ((data.value(forKey: "maxWater") as! Double) / 10) // update the water level as needed
                data.setValue(newWaterLevel, forKey: "waterLevel")
                if newWaterLevel >= data.value(forKey: "maxWater") as! Double {
                            context.delete(data)
                    rUser?.setValue(rUser?.value(forKey: "point") as! Int+10, forKey: "point")
                    loadData()
                    viewDidLoad()
                        }
                try context.save()

            }
            
            tvUsersPlant.reloadData()
        } catch {
            print("Error")
        }
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        lbWelcome.text = "Welcome, " + (rUser?.value(forKey: "username") as? String ?? "")
        if let point = rUser?.value(forKey: "point") as? Int {
            lbPoint.text = String(point) + " pts"
        } else {
            lbPoint.text = "0 pts"
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        tvUsersPlant.delegate = self
        tvUsersPlant.dataSource = self
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        // load data berdasarkan array yang ada

        arrOfNames.removeAll()
        arrOfWaterLevel.removeAll()
        arrOfHeight.removeAll()
        arrOfImage.removeAll()
        
        // select all dan masukin ke arraynya
        guard let email = rUser?.value(forKey: "email") as? String else {
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersPlants")
        let predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            for data in results {
                arrOfNames.append(data.value(forKey: "name") as! String)
                arrOfWaterLevel.append(data.value(forKey: "waterLevel") as! Double)
                arrOfHeight.append(data.value(forKey: "height") as! Double)
                arrOfImage.append(data.value(forKey: "image") as! String)
                arrOfMaxWater.append(data.value(forKey: "maxWater") as! Double)
            }
            
            tvUsersPlant.reloadData()
        } catch {
            print("Error")
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
