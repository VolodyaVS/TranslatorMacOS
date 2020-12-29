//
//  ViewController.swift
//  Translator
//
//  Created by Vladimir Stepanchikov on 20.02.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextViewDelegate {

    @IBOutlet weak var popUpFrom: NSPopUpButton!
    @IBOutlet weak var popUpTo: NSPopUpButton!
    @IBOutlet var textFrom: NSTextView!
    @IBOutlet var textTo: NSTextView!
    
    @IBOutlet weak var labelError: NSTextField!
    
    @IBOutlet weak var buttonChangeLang: NSButton!
    @IBOutlet weak var buttonTranslate: NSButton!
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    @IBOutlet weak var buttonCopy: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpFrom.removeAllItems()
        popUpTo.removeAllItems()

        textFrom.delegate = self
        
        for lang in languages {
            popUpFrom.addItem(withTitle: lang.name)
            popUpTo.addItem(withTitle: lang.name)
        }
        
        popUpFrom.selectItem(at: indexFromLang)
        popUpTo.selectItem(at: indexToLang)
         
        textFrom.string = savedText
        
    }
    
    override func viewDidAppear() {
        buttonTranslateAction(self)
    }
    
    @IBAction func popUpFromAction(_ sender: Any) {
        buttonTranslateAction(self)
        indexFromLang = popUpFrom.indexOfSelectedItem
    }
    
    @IBAction func popUpToAction(_ sender: Any) {
        buttonTranslateAction(self)
        indexToLang = popUpTo.indexOfSelectedItem
    }
    
    @IBAction func buttonChangeLangAction(_ sender: Any) {
        let langBuf: Int = popUpTo.indexOfSelectedItem
        popUpTo.selectItem(at: popUpFrom.indexOfSelectedItem)
        popUpFrom.selectItem(at: langBuf)
        
        buttonTranslateAction(self)
        
        indexFromLang = popUpFrom.indexOfSelectedItem
        indexToLang = popUpTo.indexOfSelectedItem
    }
    
    @IBAction func buttonTranslateAction(_ sender: Any) {
        labelError.stringValue = ""
        
        if textFrom.string == "" {
            return
        }
        
        buttonTranslate.isEnabled = false
        
        indicator.startAnimation(self)
        
        let langFrom = languages[popUpFrom.indexOfSelectedItem].code
        let langTo = languages[popUpTo.indexOfSelectedItem].code
        
        translate(fromLang: langFrom, toLang: langTo, text: textFrom.string) { (textTranslated, error) in
            
            DispatchQueue.main.async {
                self.indicator.stopAnimation(self)
                self.buttonTranslate.isEnabled = true
                
                if let error = error {
                    self.labelError.stringValue = error
                }
                
                self.textTo.string = textTranslated ?? ""
            }

        }
    }
    
    @IBAction func buttonCopyAction(_ sender: Any) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(textTo.string, forType: .string)
    }
    
    var timer: Timer?
    
    func textDidChange(_ notification: Notification) {
        savedText = textFrom.string
            
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.buttonTranslateAction(self)
        })
    }
    

}

