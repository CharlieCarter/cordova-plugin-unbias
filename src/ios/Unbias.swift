import UIKit
import Foundation

@objc(Unbias) class Unbias : CDVPlugin {
    @objc(test:)
    func test(_ command: CDVInvokedUrlCommand) { // write the function code.
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */
        
        // get device model name
        let modelName = UIDevice.modelName
        
        if let articles = getJSONContents() as? String {
            // Set the plugin result to fail.
            var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: articles);
            // Set the plugin result to succeed.
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: articles);
            // Send the function result back to Cordova.
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        } else {
            // Set the plugin result to fail.
            var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAsBool: false);
            // Set the plugin result to succeed.
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsBool: false);
            // Send the function result back to Cordova.
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
    }
    
    @objc(delJSON:)
    func delJSON(_ command: CDVInvokedUrlCommand) { // write the function code.
        /*
         * Always assume that the plugin will fail.
         * Even if in this example, it can't.
         */
        
            deleteArticlesJSON()
        
            // Set the plugin result to fail.
            var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "Delete Json attempt Failed");
            // Set the plugin result to succeed.
            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Delete Json attempt succeeded");

            // Send the function result back to Cordova.
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
        }
}


public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

public func doesJSONExist() -> Bool { // checks if JSON file exists
    let fileManager = FileManager.default
    if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.exeter.Unbias") {
        let newDirectory = directory.appendingPathComponent("articles")
        
        // check if directory exists
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: newDirectory.path, isDirectory: &isDir) {
            if (isDir.boolValue) {
                print("directory exists in app group group.com.exeter.Unbias.")
            } else {
                print("directory does not exist in app group group.com.exeter.Unbias.")
                return false
            }
        }
        
        // File path with json doc
        let filePath = newDirectory.appendingPathComponent("articles.json")
        
        var doesFileExist = false;
        
        doesFileExist = fileManager.fileExists(atPath: filePath.path)
        print("It is \(doesFileExist) that the file exists at \(filePath.path)")
        
        if(doesFileExist) {
            return true
        } else {
            return false
            print("File does not exist")
        }
    }
    return false
}

public func getJSONContents() -> NSString? { // get contents of JSON file
    let fileManager = FileManager.default
    print("In getJSONContents function.")
    
    if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.exeter.Unbias") {
        let newDirectory = directory.appendingPathComponent("articles")
        
        // File path with json doc
        let filePath = newDirectory.appendingPathComponent("articles.json")
        
        // check if shared file already exists
        let doesFileExist = doesJSONExist();
        // if it does, then fetch its contents
        if(doesFileExist) {
            do {
                print("Found JSON Contents. Returning.")
                let contents = try String(contentsOf: filePath) as NSString
                return(contents)
            } catch {
                print(error)
                return "File does not exist"
            }
        } else {
            print("File does not exist")
        }
    }
    return nil
}


func deleteArticlesJSON() { // deletes JSON file
    let fileManager = FileManager.default
    print("In deleteArticlesJSON function.")
    
    if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.exeter.Unbias") {
        let newDirectory = directory.appendingPathComponent("articles")
        
        // check if directory exists
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: newDirectory.path, isDirectory: &isDir) {
            if (isDir.boolValue) {
                print("directory exists in app group group.com.exeter.Unbias.")
            } else {
                print("directory does not exist in app group group.com.exeter.Unbias.")
                return
            }
        }
        
        // File path with json doc
        let filePath = newDirectory.appendingPathComponent("articles.json")
        var doesFileExist = false;
        
        doesFileExist = fileManager.fileExists(atPath: filePath.path)
        print("It is \(doesFileExist) that the file exists at \(filePath.path)")
        
        if(doesFileExist) {
            do {
                try fileManager.removeItem(atPath: filePath.path)
                print("file removed")
            } catch {
                print(error)
            }
        }
    }
}
