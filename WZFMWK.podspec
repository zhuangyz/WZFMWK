Pod::Spec.new do |s|
  s.name         = 'WZFMWK'
  s.summary      = '一些自用的、通用的、业务逻辑无关的类别/工具类。'
  s.version      = '0.0.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'zhuangyz' => '632647076@qq.com' }
  s.homepage     = 'https://www.baidu.com'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/zhuangyz/WZFMWK.git', :tag => '0.0.1' }
  s.requires_arc = true

  s.subspec 'Utils' do |utils|
    utils.public_header_files = 'WZFMWK/Utils/*.h'
    utils.source_files = 'WZFMWK/Utils/*.{h,m}'
    utils.subspec 'Categories' do |c|
      c.public_header_files = 'WZFMWK/Utils/Categories/WZCategoriesHeader.h'
      c.source_files = 'WZFMWK/Utils/Categories/WZCategoriesHeader.h'
      c.subspec 'Foundation' do |f|
        f.public_header_files = 'WZFMWK/Utils/Categories/Foundation/*.h'
        f.source_files = 'WZFMWK/Utils/Categories/Foundation/*.{h,m}'
      end
      c.subspec 'UIKit' do |k|
        k.public_header_files = 'WZFMWK/Utils/Categories/UIKit/*.h'
        k.source_files = 'WZFMWK/Utils/Categories/UIKit/*.{h,m}'
      end
    end

    utils.subspec 'Tools' do |t|
      t.source_files = 'WZFMWK/Utils/Tools/*.{h,m}'
      t.public_header_files = 'WZFMWK/Utils/Tools/*.h'
      t.dependency 'INTULocationManager'
      t.dependency 'WZFMWK/Utils/Categories'
    end
  end

  s.subspec 'Core' do |core|
    core.dependency 'WZFMWK/Utils'
  end
  s.default_subspec = 'Core'

end
