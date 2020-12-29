//
//  YandexDate.swift
//  Translator
//
//  Created by Vladimir Stepanchikov on 24.02.2020.
//  Copyright © 2020 Vladimir Stepanchikov. All rights reserved.
//

import Foundation

struct Lang {
    var name: String
    var code: String
}

let languages: [Lang] = [
    Lang (name: "английский", code: "en"),
    Lang (name: "итальянский", code: "it"),
    Lang (name: "испанский", code: "es"),
    Lang (name: "немецкий", code: "de"),
    Lang (name: "русский", code: "ru"),
    Lang (name: "французский", code: "fr")
]

let codes: [Int: String] =
    [200: "Операция выполнена успешно",
     401: "Неправильный API-ключ",
     402: "API-ключ заблокирован",
     404: "Превышено суточное ограничение на объем переведенного текста",
     413: "Превышен максимально допустимый размер текста",
     422: "Текст не может быть переведен",
     501: "Заданное направление перевода не поддерживается"]
 
