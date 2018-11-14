//
//  VerSnapViewController.swift
//  SnapchatApp
//
//  Created by Yanela Pachacama Quispe on 9/11/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var snap = Snap()
    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text? = snap.descrip
        imageView.sd_setImage(with: URL(string : snap.imagenURL))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRDatabase.database().reference().child("usuarios").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.id).removeValue()
        
        FIRStorage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete{(error) in
            print("se eliminó la imagen correctamente")
        }
        
        FIRStorage.storage().reference().child("audios").child("\(snap.audioID).m4a").delete{(error)
            in print("Se eliminó correctamente el audio")
        }
    }
    
    @IBAction func iniciarAudio(_ sender: Any) {
        
        let pathString = snap.audioID
        let storageReference = FIRStorage.storage().reference().child("audios").child("\(pathString).m4a")
        let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let fileUrl = fileUrls.first?.appendingPathComponent(pathString) else {
            return
        }
        
        let downloadTask = storageReference.write(toFile: fileUrl)
        
        downloadTask.observe(.success) { _ in
            do {
                self.player = try AVAudioPlayer(contentsOf: fileUrl)
                self.player?.prepareToPlay()
                self.player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
