//
//  ImagenViewController.swift
//  YagunoSnapchat
//
//  Created by Angel Yaguno on 21/10/24.
//

import UIKit
import FirebaseStorage

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    
    var imagenID = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    

    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        
        guard let imagen = imageView.image, let imagenData = imagen.jpegData(compressionQuality: 0.50) else {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo obtener la imagen para subir.", accion: "Aceptar")
            return
        }

        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let nombreImagen = "\(NSUUID().uuidString).jpg"
        let imagenRef = imagenesFolder.child("\(imagenID).jpg")
        
        let cargarImagen = imagenRef.putData(imagenData, metadata: nil) { (metadata, error) in
            if let error = error {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexión a Internet y vuelva a intentarlo.", accion: "Aceptar")
                self.elegirContactoBoton.isEnabled = true
                print("Ocurrió un error al subir la imagen: \(error.localizedDescription)")
            } else {
                imagenRef.downloadURL { (url, error) in
                    if let error = error {
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener información de la imagen.", accion: "Cancelar")
                        print("Ocurrió un error al obtener la información de la imagen: \(error.localizedDescription)")
                        return
                    }
                    
                    if let enlaceURL = url {
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: enlaceURL.absoluteString)
                    }
                }
            }
        }
    }

        /*
        let alertaCarga = UIAlertController(title: "Cargando imagen ...", message: "0%", preferredStyle: .alert)
        let progresoCarga : UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            progresoCarga.setProgress(Float(porcentaje), animated: true)
            progresoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje >= 1.0 {
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(progresoCarga)
        present(alertaCarga, animated: true, completion: nil)
        */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.imagenID = imagenID
//        let imagenesFolder = Storage.storage().reference().child("imagenes")
//        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
//        imagenesFolder.child("imagenes.jpg").putData(imagenData!, metadata: nil) { (metadata, error) in
//            if error != nil {
//                print("Ocurrio un error al subir la imagen: \(error?.localizedDescription)")
//            }
//        }
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
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
