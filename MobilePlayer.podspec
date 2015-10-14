Pod::Spec.new do |s|
  s.name             = "MobilePlayer"
  s.version          = "1.0.1"
  s.summary          = "A powerful and completely customizable media player for iOS."
  s.homepage         = "https://github.com/mobileplayer/mobileplayer-ios"
  s.license          = 'CC'
  s.author           = { "Barış Şencan" => "baris.sncn@gmail.com",
                         "Toygar Dündaralp" => "tdundaralp@gmail.com",
                         "Cem Olcay" => "ccemolcay@gmail.com",
                         "Şahin Boydaş" => "sahinboydas@gmail.com" }
  s.source           = { :git => "https://github.com/mobileplayer/mobileplayer-ios.git", :tag => s.version.to_s }
  s.platform         = :ios, '8.0'
  s.requires_arc     = true
  s.frameworks       = 'UIKit', 'MediaPlayer'
  s.source_files     = 'MobilePlayer/**/*.swift'
  #s.resource_bundle  = { 'MobilePlayer' => 'MobilePlayer/Images.xcassets' }
  s.resources        = ["MobilePlayer/Images.xcassets/MLCloseButton.imageset/CloseButton.pdf", 
                        "MobilePlayer/Images.xcassets/MLIncreaseVolume.imageset/MLIncreaseVolume.pdf", 
                        "MobilePlayer/Images.xcassets/MLPauseButton.imageset/PauseButton.pdf",
                        "MobilePlayer/Images.xcassets/MLPlayButton.imageset/PlayButton.pdf",
                        "MobilePlayer/Images.xcassets/MLReduceVolume.imageset/MLReduceVolume.pdf",
                        "MobilePlayer/Images.xcassets/MLShareButton.imageset/ShareButton.pdf",
                        "MobilePlayer/Images.xcassets/MLVolumeButton.imageset/MLVolumeButton.pdf"]
end
