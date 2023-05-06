//
//  PointViewController.swift
//  GrowWell
//
//  Created by Guido william on 27/04/23.
//

import UIKit
import CoreData

class PointViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tvPoint: UITableView!
    var context:NSManagedObjectContext!
    var arrOfEmail = [String]()
    var arrOfPoint = [Int]()
    var rUser: NSManagedObject?

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfEmail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // data tiap cellnya dikasih apa
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PointTableViewCell
        print(arrOfEmail[indexPath.row])
        cell.lbEmail.text = arrOfEmail[indexPath.row]
        cell.lbPoint.text = String(arrOfPoint[indexPath.row])
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        tvPoint.delegate = self
        tvPoint.dataSource = self
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        arrOfEmail.removeAll()
        arrOfPoint.removeAll()

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Users")

        do {
            let results = try context.fetch(fetchRequest)
            for data in results {
                print(data.value(forKey: "email") as! String)
                arrOfEmail.append(data.value(forKey: "email") as! String)
                arrOfPoint.append(data.value(forKey: "point") as! Int)
            }

            tvPoint.reloadData()
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
