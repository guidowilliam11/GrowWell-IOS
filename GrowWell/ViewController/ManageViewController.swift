//
//  ManageViewController.swift
//  GrowWell
//
//  Created by Guido william on 26/04/23.
//

import UIKit
import CoreData

class ManageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfName: UITextField!
    
    @IBOutlet weak var tfMaxWater: UITextField!
    
    @IBOutlet weak var tfImage: UITextField!
    
    @IBOutlet weak var tfHeight: UITextField!
    
    @IBOutlet weak var ivImage: UIImageView!
    
    var rUser: NSManagedObject?
    
    var context:NSManagedObjectContext!
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let urlString = tfImage.text!
        let url = URL(string: urlString)!
        guard let data = try? Data(contentsOf: url) else{
            return
        }
        ivImage.image = UIImage(data: data)
        }
    
    @IBAction func btnInsert(_ sender: Any) {
        let name = tfName.text
        let maxWater = tfMaxWater.text
        let Image = tfImage.text
        let height = tfHeight.text
        let email = rUser?.value(forKey: "email")
        
        let entity = NSEntityDescription.entity(forEntityName: "UsersPlants", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(email, forKey: "email")
        newUser.setValue(name, forKey: "name")
        let maxWaterNumber = NSNumber(value: Double(maxWater!)!)
        newUser.setValue(maxWaterNumber, forKey: "maxWater")
        newUser.setValue(Image, forKey: "image")
        let heightNumber = NSNumber(value: Double(height!)!)
        newUser.setValue(heightNumber, forKey: "height")
        newUser.setValue(0, forKey: "waterLevel")

        
        do {
               try context.save()
            
            guard let tabBarController = self.tabBarController else {
                return
            }
            guard let homeNavigationController = tabBarController.viewControllers?.first as? UINavigationController else {
                return
            }
            guard let homeViewController = homeNavigationController.topViewController as? HomeViewController else {
                return
            }
            homeViewController.loadData()

            tabBarController.selectedIndex = 0
           } catch {
               print("Error saving managed object context: \(error)")
           }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tfImage.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
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




