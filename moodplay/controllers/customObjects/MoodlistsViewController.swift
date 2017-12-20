//
//  MyProfileViewController.swift
//  moodplay
//
//  Created by Matteo Russo on 19/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//
import Foundation
import UIKit

class MoodlistsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false //LUL?
        self.present(image, animated: true){
            //After it is complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Avoid crash if error changin' picture
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            myImageView.image = image
        }else{
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Radius Image
        myImageView.layer.cornerRadius = myImageView.frame.size.width/2
        myImageView.clipsToBounds = true
        
        
        self.navigationItem.title = "My Profile"
    self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

