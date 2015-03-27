#
#  Be sure to run `pod spec lint CCMRadarView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CCMRadarView"
  s.version      = "1.0.0"
  s.summary      = "CCMRadarView uses the IBDesignable tools to make an easy customizable radar view with animation"
  s.description  = <<-DESC
                   CCMRadarView is a simple to use view that uses the new IBDesignable and IBInspectable features of XCode6 to easily configure the icon in the center, the width of the waves of the radar, as well as the color, the number of waves,etc.
                   DESC

  s.homepage     = "https://github.com/cacmartinez/CCMRadarView"
  s.screenshots  = "https://raw.githubusercontent.com/cacmartinez/CCMRadarView/master/Screenshots/iOS%20Simulator%20Screen%20Shot%2028.11.2014%2012.54.37.png"
  s.license      = { :type => "APACHE 2.O", :file => "LICENSE" }
  s.author             = { "Carlos Compean" => "cacmartinez@icalialabs.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/cacmartinez/CCMRadarView.git", :tag => s.version.to_s }
  s.source_files  = "Classes", "CCMRadarView/**/*.{h,m,swift}"
  s.requires_arc = true

end
