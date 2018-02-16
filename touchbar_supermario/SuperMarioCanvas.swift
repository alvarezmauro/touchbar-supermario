//
//  ViewController.swift
//  touchbar_supermario based in touchbar_nyancat (Aslan Vatsaev)
//
//  Created by Mauro Alvarez on 16/02/2018.
//

import Cocoa

class SuperMarioCanvas: NSImageView {
    @objc var timer:Timer? = nil

    @objc var imageLoaded:Bool = false;

    @objc var xPosition: CGFloat = -30 {
        didSet {
            self.frame = CGRect(x: xPosition, y: 0, width: 30, height: 30)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        self.animates = true
        
        if(self.timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.moveMario), userInfo: nil, repeats: true)
        }

        if(!self.imageLoaded){
            self.downloadImage()
        }
        
        self.canDrawSubviewsIntoLayer = true
        self.frame = CGRect(x: xPosition, y: 0, width: 30, height: 30)
    }
    
    override func touchesBegan(with event: NSEvent) {
        // Calling super causes the cat to jump back to its original position 🤔
        //super.touchesBegan(with: event)
    }
    
    override func didAddSubview(_ subview: NSView) {
        
    }
    
    @objc public func moveMario() {
        if (xPosition < 325) {
            xPosition += 1
        }else if (xPosition > 355){
            xPosition -= 1
        }
    }

    @objc func downloadImage() {
        self.image = NSImage(named: NSImage.Name(rawValue: "mario.gif"))
        self.imageLoaded = true;
    }
    
    @objc func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    

    
    override func touchesMoved(with event: NSEvent) {
        if #available(OSX 10.12.2, *) {
            let current = event.allTouches().first?.location(in: self).x ?? 0
            let previous = event.allTouches().first?.previousLocation(in: self).x ?? 0
        
            let dX = (current - previous)
            
            xPosition += dX
        } else {
            // Fallback on earlier versions
        }
    }
    
}
