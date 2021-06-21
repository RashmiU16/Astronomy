//
//  ViewController.swift
//  AstronomyPicture
//
//  Created by Rashmi uppin on 6/20/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var pictureTitleLabel: UILabel!
    
    @IBOutlet weak var atronomyPicture: UIImageView!
    
    @IBOutlet weak var pictureDescriptionTV: UITextView!
    
    @IBOutlet weak var explanationLabel: UILabel!
    var astronomyData = astronomyPictureDetails()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Utility.isConnectedToNetwork(){
            
            getAtronomyData()
        } else {
            
            retrieveData()
        }
        // Do any additional setup after loading the view.
    }
    func getAtronomyData() {
        var request = URLRequest(url: URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let httpResponse = response as! HTTPURLResponse
                print("httpResponse.statusCode\(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    let astornomyPictureModel = try jsonDecoder.decode(astronomyPictureDetails.self, from: data!)
                    print(astornomyPictureModel)
                    
                    self.updateUIData(astronomyData1: astornomyPictureModel)
                } else {
                    print("Error: did not receive data")
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }).resume()
    }
    func updateUIData(astronomyData1: astronomyPictureDetails) {
        DispatchQueue.main.async {
            self.pictureTitleLabel.text = astronomyData1.title
            self.pictureDescriptionTV.text = astronomyData1.explanation
            self.explanationLabel.text = "Picture explanation"
        }
        DispatchQueue.global(qos: .background).async {
            do
             {
                let data = try Data.init(contentsOf: URL.init(string:astronomyData1.url ?? "")!)
                DispatchQueue.main.async {
                    let image: UIImage = UIImage(data: data)!
                    self.atronomyPicture.image = image
                    self.createData(data: astronomyData1)
                }
             }
            catch {
                print("Error: image conversion failed")
            }
        }
        
    }
    
    func createData(data: astronomyPictureDetails){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        
        let imageData = (self.atronomyPicture.image?.pngData())! // image in PNG format
        
        
        let userEntity = NSEntityDescription.entity(forEntityName: "AstronomyData", in: managedContext)!
         
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(data.title, forKeyPath: "pictureTitle")
        user.setValue(data.explanation, forKey: "pictureExplanation")
        user.setValue(imageData, forKey: "pictureImage")
        
        user.setValue(data.date, forKey: "date")

        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AstronomyData")
        
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
//        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
//
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "pictureTitle") as! String)
                astronomyData.title = data.value(forKey: "pictureTitle") as? String
                astronomyData.explanation = data.value(forKey: "pictureExplanation") as? String
                astronomyData.imageData = data.value(forKey: "pictureImage") as? Data
                astronomyData.date = data.value(forKey: "date") as? String
                
            }
            if astronomyData.title == nil {
                Utility.AlertController(title: "", message: "We are not connected to the internet.There is no last seen also, so connect to network", view: self)
                DispatchQueue.main.async {
                self.explanationLabel.text = ""
                }
            } else {
                Utility.AlertController(title: "", message: "We are not connected to the internet, showing you the last image we have.", view: self)
                DispatchQueue.main.async {
                    self.pictureTitleLabel.text = self.astronomyData.title
                    self.pictureDescriptionTV.text = self.astronomyData.explanation
                    self.atronomyPicture.image = UIImage(data: self.astronomyData.imageData!)
                    self.explanationLabel.text = "Picture explanation"
                }
            }
            
            
            
        } catch {
            
            print("Failed")
        }
    }
    
    
}



