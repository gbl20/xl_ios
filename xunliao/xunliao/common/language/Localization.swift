import Foundation
class Localization: ObservableObject {
    static let shared = Localization()
    
    private var languageBundle: Bundle?
    
    @Published var languageCode: String = "" {
        didSet {
            
            UserDefaults.standard.setValue(languageCode, forKey: "AppLanguageCode")
            self.updateLanguage()
        }
    }
    
    init() {
        if let savedLanguageCode = UserDefaults.standard.string(forKey: "AppLanguageCode") {
            languageCode = savedLanguageCode
        } else {
            languageCode = Locale.current.languageCode ?? "en"
        }
        self.updateLanguage()
    }
    
    private func updateLanguage() {
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") {
            languageBundle = Bundle(path: path)
        } else {
            languageBundle = Bundle.main
        }
    }
    
    // 提供一个公开的方法来更改语言
    func changeLanguage(to languageCode: String) {
        self.languageCode = languageCode // 这将触发 setter 并保存新的语言代码到 UserDefaults
    }
    
    func local(key: String, tableName: String? = nil) -> String{
        return NSLocalizedString(key, tableName: tableName, bundle: languageBundle ?? .main, comment: key).localizedCapitalized
    }
}
