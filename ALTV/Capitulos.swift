//
//  Capitulos.swift
//  ALTV
//
//  Created by Alan Olivares on 30/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit

class Capitulos: UIViewController {
    var paso = [SerieObjeto]()
    var va = 0
    var cap = [String: AnyObject]()
    var link = [String]()
    @IBOutlet var imageSerie: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let objeto = paso
        let val = va
        let url = NSURL(string: objeto[val].imagen)!
        let data = NSData(contentsOf: url as URL)
        self.imageSerie.image=UIImage(data: data! as Data)
        
        print(val)
        
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
