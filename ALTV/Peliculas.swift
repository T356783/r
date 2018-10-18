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
import Foundation
let imageCache = NSCache<NSString, UIImage>()
class Peliculas: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var peliculasOb = [PeliObjeto]()
    var currentPeli = [PeliObjeto]()
    @IBOutlet weak var tableViewPe: UITableView!
    @IBOutlet var searchBarPeli: UISearchBar!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewPe.dataSource = self
        tableViewPe.delegate = self
        searchBarPeli.delegate = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let myURLString = "https://pastebin.com/raw/7hw1WvqR"
        
        
        if let myURL = NSURL(string: myURLString) {
            do {
                let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                extractChannelsFromRawString(myHTMLString as String)
            } catch {
                print(error)
            }
        }
        currentPeli = peliculasOb
        self.tableViewPe.reloadData()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPeli.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom2", for: indexPath) as! Pelicula
        let urlString = currentPeli[indexPath.row].imagen //Lista con las URLs
        let url = URL(string: urlString)!
        //let data = NSData(contentsOf: url as URL)
        //cell.imagen.image=UIImage(data: data! as Data)
        //
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data as Data) {
                    DispatchQueue.main.async {
                        cell.imagen.image=image
                        //cell.numero.text=String (indexPath.row+1)
                        //cell.nombre.text=self?.currentPeli[indexPath.row].name
                    }
                }
            }
        }
        
        //cell.imagen.image=cacheImage(urlString: urlString)
        cell.numero.text=String (indexPath.row+1)
        cell.nombre.text=currentPeli[indexPath.row].name
        //
        return cell
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentPeli = peliculasOb
            tableViewPe.reloadData()
            return
        }
        currentPeli = peliculasOb.filter({pelicula -> Bool in
            pelicula.name.lowercased().contains(searchText.lowercased())
        })
        tableViewPe.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = URL(string: currentPeli[indexPath.row].link)
        print(currentPeli[indexPath.row].imagen)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = LandscapeAVPlayerController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
    /*func cacheImage(urlString: String) ->(UIImage){
        var envia: UIImage? = nil
        let url = URL(string: urlString)
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? AnyObject {
            envia = imageFromCache as? UIImage
        }
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if let response = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: (urlString as AnyObject) as! NSString)
                    envia = imageToCache!
                }
            }
            }.resume()
        return envia!
    }*/
    func extractChannelsFromRawString(_ string: String) {
        var namee = ""
        var linkIm2 = ""
        var linkIm3 = ""
        string.enumerateLines { line, shouldStop in
            if line.hasPrefix("#EXTINF:") {
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let infoItems = infoLine.components(separatedBy: ",")
                if let title = infoItems.last {
                    namee = title
                }
            }
            if line.hasPrefix("#EXTINF:-1"){
                let val2 = line.components(separatedBy: " ")
                for sep in val2{
                    if sep.hasPrefix("tvg-logo="){
                        let sep2 = sep.components(separatedBy: ",")
                        let sep1 = sep2[0]
                        let indexStartOfText = sep1.index(sep1.startIndex, offsetBy: 10)
                        linkIm2 = String(sep1[indexStartOfText...])
                        let indexEndOfText = linkIm2.index(linkIm2.endIndex, offsetBy: -1)
                        linkIm3 = String(linkIm2[..<indexEndOfText])
                    }
                }
            }else {
                if line.hasPrefix("http"){
                    self.peliculasOb.append(PeliObjeto(name: namee, imagen: linkIm3, link: line))
                    linkIm3 = ""
                }
            }
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


