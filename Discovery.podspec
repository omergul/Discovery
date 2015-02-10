Pod::Spec.new do |s|
  s.name         = "Discovery"
  s.version      = "1.0.0"
  s.summary      = "Discovery: A simple library to discover and retrieve data from nearby devices."
  s.description  = <<-DESC
                   Discovery is a very simple but useful library for discovering nearby devices with BLE and to exchange a value (kind of ID or username determined by you on the running app on peer device) wheather the app on peer device is working at foregorund or background state.

Discovery:
* lets you easily discover nearby devices
* retrieve their id(assigned by you) wheather the app works on foreground or background state
* hides the nitty gritty details of BLE calls and delegates from the developer
* determines the proximity of the peer device
                   DESC

  s.homepage     = "https://github.com/omergul123/Discovery"
  s.license      = { :type => 'APACHE', :file => 'LICENSE' }
  s.author       = { "Ömer Faruk Gül" => "omer.gul@louvredigital.com" }
  s.platform     = :ios,'7.0'
  s.source       = { :git => "https://github.com/omergul123/Discovery.git", :tag => "v1.0.0" }
  s.source_files  = 'Discovery/*.{h,m}'
  s.requires_arc = true
  s.framework = 'CoreBluetooth', 'CoreLocation'
end
