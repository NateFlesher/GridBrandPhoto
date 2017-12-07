# Podfile
use_frameworks!

target 'postcraft' do
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'MRCountryPicker', '~> 0.0.5'
    pod 'SwiftSpinner'
    pod 'SQLite.swift/standalone', '~> 0.11.2'
    pod 'SQLiteMigrationManager.swift'
    pod 'Fakery'
    pod 'Popover'
    pod 'KSTokenView', '~> 3.1'
    pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
    pod 'RxAlamofire'
    pod 'Toast-Swift', '~> 2.0.0'
end

# RxTests and RxBlocking make the most sense in the context of unit/integration tests
target 'postcraftTests’ do
    pod 'RxBlocking', '~> 3.0'
    pod 'RxTest',     '~> 3.0'
end
