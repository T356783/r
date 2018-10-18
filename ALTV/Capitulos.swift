//
//  Capitulos.swift
//  ALTV
//
//  Created by Alan Olivares on 30/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class Capitulos: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var paso = [SerieObjeto]()
    var va = ""
    var imageSe = ""
    var cap = [String]()
    var link = [String]()
    @IBOutlet var imageSerie: UIImageView!
    
    @IBOutlet var tableViewCap: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCap.delegate = self
        tableViewCap.dataSource = self
        let url = NSURL(string: imageSe)!
        let data = NSData(contentsOf: url as URL)
        self.imageSerie.image=UIImage(data: data! as Data)
        self.title = va
        buscarCapitulos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func buscarCapitulos(){
        for capi in paso {
            if(capi.name == va){
                cap.append(capi.capitulo)
                link.append(capi.link)
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cap.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom4", for: indexPath) as! Capitulo
        cell.verCapitulo.text = cap[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = URL(string: link[indexPath.row])
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
class Capitulo:UITableViewCell{
    @IBOutlet var verCapitulo: UILabel!
    
}
