# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'
use_frameworks!

target 'RentalCar' do

pod 'SnapKit'
pod 'FSCalendar'
pod 'Kingfisher', '~> 7.0'
# pod 'YandexMapsMobile', '4.0.0-lite'
pod "BSImagePicker", "~> 3.1"
pod 'Alamofire'

end

post_install do |installer|

  # Изменяем таргет с каждого пода с 8 на таргет проекта принудительно, чтобы убрать ворнинги икскода
  # 8ой таргет больше не поддерживается эплом

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
    end
  end
end
