//
//  VerSnapViewController.swift
//  YagunoSnapchat
//
//  Created by Angel Yaguno on 28/10/24.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    
    var snap = Snap()

    override func viewDidLoad() {
        super.viewDidLoad()

        lblMensaje.text = "Mensaje: " + snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete { (error) in
            print("Se elimino la imagen correctamente")
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
