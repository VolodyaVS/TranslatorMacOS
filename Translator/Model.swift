//
//  Model.swift
//  Translator
//
//  Created by Vladimir Stepanchikov on 23.02.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Foundation

var strUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate"
var key = "trnsl.1.1.20200224T074859Z.8e0ff5cb319fbe07.bc1edc93f3d06ba489d7fd5995d48d6c84a4ddca"

/*
 https://translate.yandex.net/api/v1.5/tr.json/translate
 ? [key=<API-ключ>]
 & [text=<переводимый текст>]
 & [lang=<направление перевода>]
 
 https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20200224T074859Z.8e0ff5cb319fbe07.bc1edc93f3d06ba489d7fd5995d48d6c84a4ddca&text=hello world&lang=en-ru
 {"code":200,"lang":"en-ru","text":["Привет мир"]}
 
 */

var savedText: String {
    get {
        return UserDefaults.standard.object(forKey: "savedText") as? String ?? ""
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "savedText")
        UserDefaults.standard.synchronize()
    }
}

var indexFromLang: Int {
    get {
        return UserDefaults.standard.integer(forKey: "indexFromLang")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "indexFromLang")
        UserDefaults.standard.synchronize()
    }
}

var indexToLang: Int {
    get {
        return UserDefaults.standard.integer(forKey: "indexToLang")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "indexToLang")
        UserDefaults.standard.synchronize()
    }
}


func translate(fromLang: String, toLang: String, text: String, completionHandler: ((_ translatedText: String?, _ error: String?) -> Void)?) {
    
    //        1 - подготовить запрос для yandex api
    
    let url = strUrl + "?key=" + key + "&lang="+fromLang+"-"+toLang
    
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "POST"
    request.httpBody = ("text="+text).data(using: String.Encoding.utf8)
    
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request) { (data, response, error) in
    
    //        2 - получить json-ответа
    //        3 - разобрать его
        
        if error != nil {
            completionHandler?(nil, error!.localizedDescription)
            return
        }
        
        guard let data = data else {
            completionHandler?(nil, "В ответе data = nil")
            return
        }
        
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>  else {
                completionHandler?(nil, "Формат json не соответствует ожидаемому")
                return
            }
            
            guard let code = dictionary["code"] as? Int else {
                completionHandler?(nil, "Отсутствует поле code в ответе")
                return
            }
            
            if code != 200 {
                completionHandler?(nil, "Ошибка при переводе: \(codes[code] ?? "")")
                return
            }
            
            guard let text = dictionary["text"] as? [String] else {
                completionHandler?(nil, "Ошибка распарсирования json: отсутствует поле текст")
                return
            }
            
            if text.count == 0 {
                completionHandler?(nil, "Ошибка распарсирования json: отсутствует поле текст, массив перевода пустой")
                return
            }
            
            //        4 - вызвать функцию completionHandler
            completionHandler?(text[0], nil)
            
        } catch {
            completionHandler?(nil, "Ошибка распарсирования json error = \(error.localizedDescription)")
            return
        }
        
    }
    
    task.resume()
    
}

