//
//  CreatePlaylistViewController.swift
//  moodplay
//
//  Created by Matteo Russo on 19/12/17.
//  Copyright © 2017 Pasquale Spisto. All rights reserved.
//

import UIKit

class CreatePlaylistViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var song: Song!
    
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
    
    
    
    @IBOutlet weak var playlistDescription: UITextField!
    @IBOutlet weak var playlistName: UITextField!
    @IBAction func done(_ sender: Any) {
        
        MoodlistDAO.shared.writeObjectToCloud(object: Moodlist(id: "", title: playlistName.text!, description: playlistDescription.text!, songs: [song], image: myImageView.image!))
        
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
