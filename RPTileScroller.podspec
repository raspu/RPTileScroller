#
# Be sure to run `pod lib lint RPTileScroller.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RPTileScroller"
  s.version          = "0.1.0"
  s.summary          = "SpriteKit Infinite Tile Scroller"
  s.description      = <<-DESC
                       A simple infinite tile scroller that uses a traditional, tableview's inspired, datasource.
                       DESC
  s.homepage         = "https://github.com/raspu/RPTileScroller"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "J.P. Illanes" => "jpillaness@gmail.com" }
  s.source           = { :git => "https://github.com/raspu/RPTileScroller.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**.{h,m}'
  s.resource_bundles = {
    'RPTileScroller' => ['Pod/Assets/*.png']
  }

end
