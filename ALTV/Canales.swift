//
//  Canales.swift
//  ALTV
//
//  Created by Alan Olivares on 23/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
class Canales: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var canalesOb = [CanalObjeto]()
    var canalO: CanalObjeto?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let urlString = "https://pastebin.com/raw/fW270XEh"
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
                        self.canalesOb.append(CanalObjeto(name: nombre, imagen: imagen, link: link))
                    }
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
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
        return canalesOb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! Canal
        let urlString = canalesOb[indexPath.row].imagen //Lista con las URLs
         let url = NSURL(string: urlString)!
         let data = NSData(contentsOf: url as URL)
         cell.imagee.image=UIImage(data: data! as Data)
        cell.number.text=String (indexPath.row+1)
        cell.nombreCa.text=canalesOb[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let alert = UIAlertController(title: can[indexPath.row], message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ver", style: .default, handler:{
            (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(NSURL(string: self.link[indexPath.row])! as URL)
        }))
        self.present(alert, animated: true, completion: nil)*/
       /* let videoURL = URL(string: link[indexPath.row])
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        player.play()*/
        let videoURL = URL(string: canalesOb[indexPath.row].link)
        print(canalesOb[indexPath.row].link)
         let player = AVPlayer(url: videoURL!)
         let playerViewController = LandscapeAVPlayerController()
         playerViewController.player = player
         self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
         }
        /*let videoURL = URL(string: "https://lh3.googleusercontent.com/X3BinraZZO9BeLb8EbKNB7WkLXYKHopmoaPm2OJEZmfAFtxm_vmzvSDnHHuW4F3WsbpmzEsKl-51VaO8VWXDNJ_I4hmsrOzOwR2PVAEqDlrMSSSiyUSAI4OybutISLm4aiyODpkqRm4=m18")
        let player = AVPlayer(url: videoURL!)
        let controller=LandscapeAVPlayerController()
        controller.player=player
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        player.play()*/
        
        /*var streamPlayer : MPMoviePlayerController =  MPMoviePlayerController(contentURL: NSURL(string:"https://lh3.googleusercontent.com/X3BinraZZO9BeLb8EbKNB7WkLXYKHopmoaPm2OJEZmfAFtxm_vmzvSDnHHuW4F3WsbpmzEsKl-51VaO8VWXDNJ_I4hmsrOzOwR2PVAEqDlrMSSSiyUSAI4OybutISLm4aiyODpkqRm4=m18") as! URL)
        streamPlayer.view.frame = self.view.bounds
        self.view.addSubview(streamPlayer.view)
        
        streamPlayer.isFullscreen = true
        // Play the movie!
        streamPlayer.play()*/
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
class Canal:UITableViewCell{
    @IBOutlet var nombreCa: UILabel!
    
    @IBOutlet var number: UILabel!
    
    @IBOutlet var imagee: UIImageView!
}

class CanalObjeto{
    var name: String
    var imagen: String
    var link: String
    init(name: String,imagen: String, link: String) {
        self.name = name
        self.imagen = imagen
        self.link = link
    }
}
