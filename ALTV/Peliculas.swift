//
//  Peliculas.swift
//  ALTV
//
//  Created by Alan Olivares on 23/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
class Peliculas: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var peliculasOb = [PeliObjeto]()
    @IBOutlet weak var tableViewPe: UITableView!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPe.dataSource = self
        tableViewPe.delegate = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let urlString = "https://pastebin.com/raw/Rwh9CRSk"
        let url = URL(string: urlString)
        let peticion = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if(error != nil){
                print("Error: \(String(describing: error))")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
                    for user in json{
                        let nombre = user["nombre"] as! String
                        let imagen = user["imagen"] as! String
                        let link = user["link"] as! String
                        self.peliculasOb.append(PeliObjeto(name: nombre, imagen: imagen, link: link))
                    }
                    OperationQueue.main.addOperation({
                        self.tableViewPe.reloadData()
                    })
                    
                } catch let error as NSError{
                    print(error)
                }
            }
        }
        
        peticion.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculasOb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom2", for: indexPath) as! Pelicula
        let urlString = peliculasOb[indexPath.row].imagen //Lista con las URLs
        let url = NSURL(string: urlString)!
        let data = NSData(contentsOf: url as URL)
        cell.imagen.image=UIImage(data: data! as Data)
        cell.numero.text=String (indexPath.row+1)
        cell.nombre.text=peliculasOb[indexPath.row].name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = URL(string: peliculasOb[indexPath.row].link)
        print(peliculasOb[indexPath.row].link)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = LandscapeAVPlayerController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
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
class PeliObjeto{
    var name: String
    var imagen: String
    var link: String
    init(name: String,imagen: String, link: String) {
        self.name = name
        self.imagen = imagen
        self.link = link
    }
    
}
class Pelicula:UITableViewCell{
    @IBOutlet var imagen: UIImageView!
    
    @IBOutlet var nombre: UILabel!
    @IBOutlet var numero: UILabel!
    
}
class LandscapeAVPlayerController: AVPlayerViewController{
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
}
