#
# Be sure to run `pod lib lint youtube-parser.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MobilePlayer"
  s.version          = "1.0.0"
  s.summary          = "A powerful and completely customizable media player for iOS."
  s.homepage         = "https://github.com/mobileplayer/mobileplayer-ios"
  s.license          = 'CC'
  s.author           = { "Toygar Dündaralp" => "tdundaralp@gmail.com",
                         "Barış Şencan" => "baris.sncn@gmail.com",
                         "Cem Olcay" => "ccemolcay@gmail.com",
                         "Şahin Boydaş" => "sahinboydas@gmail.com" }
  s.source           = { :git => "https://github.com/mobileplayer/mobileplayer-ios.git", :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.source_files     = 'MobilePlayer'

end
