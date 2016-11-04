Pod::Spec.new do |s|
s.name         = "APHelperCategory"
s.version      = "0.0.1"
s.summary      = "NSString-APHelper Category"
s.homepage              = "https://github.com/tigrim/NSString-APHelper"
s.license               = { :type => 'MIT', :file => 'LICENSE' }
s.author                = { "tigrim" => "baltazavr@i.ua" }
s.platform              = :ios, '7.0'
s.source                = { :git => "https://github.com/tigrim/NSString-APHelper.git", :tag => s.version.to_s }
s.source_files          = 'Classes/*.{h,m}'
s.public_header_files   = 'Classes/*.h'
s.framework             = 'Foundation'
s.requires_arc          = true
end
