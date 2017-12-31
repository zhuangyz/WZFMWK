Pod::Spec.new do |s|
  s.name         = 'WZFMWK'
  s.summary      = '一些自用的、通用的、业务逻辑无关的类别/工具类。'
  s.version      = '0.1.2'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'zhuangyz' => '632647076@qq.com' }
  s.homepage     = 'https://www.baidu.com'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/zhuangyz/WZFMWK.git', :tag => s.version.to_s }
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

  s.subspec 'WZPhotoBrowser' do |pb|
    pb.source_files = 'WZFMWK/WZPhotoBrowser/*.{h,m}'
    pb.public_header_files = 'WZFMWK/WZPhotoBrowser/WZPhotoBrowser.h', 'WZFMWK/WZPhotoBrowser/WZPhoto.h', 'WZFMWK/WZPhotoBrowser/UIViewController+WZPhotoBrowser.h'
    pb.dependency 'SDWebImage', '~> 4.0'
  end

  s.subspec 'WZHTTPNetworking' do |net|
    net.source_files = 'WZFMWK/WZHTTPNetworking/*.{h,m}'
    net.public_header_files = 'WZFMWK/WZHTTPNetworking/*.h'
    net.dependency 'AFNetworking', '~> 3.1.0'
  end

  s.subspec 'Core' do |core|
    core.dependency 'WZFMWK/Utils'
    core.dependency 'WZFMWK/WZHTTPNetworking'
    core.dependency 'WZFMWK/WZPhotoBrowser'
  end
  s.default_subspec = 'Core'

  s.subspec 'WZEmojiRichText' do |emoji|
    emoji.public_header_files = 'WZFMWK/WZEmojiRichText/*.h'
    emoji.source_files = 'WZFMWK/WZEmojiRichText/*.{h,m}'
    emoji.resources = 'WZFMWK/WZEmojiRichText/WZEmojiBundle.bundle'
  end

end
