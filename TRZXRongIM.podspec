Pod::Spec.new do |s|
    s.name         = "TRZXRongIM"
    s.version      = "0.2.9"
    s.ios.deployment_target = "8.0"
    s.summary      = "A delightful setting interface framework."
    s.homepage     = "https://github.com/TRZXDev/TRZXRongIM"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "bicassos" => "bicassos@outlook.com" }
    s.source       = { :git => "https://github.com/TRZXDev/TRZXRongIM.git", :tag => s.version }



#   |文件夹1层
    s.source_files  = "TRZXRongIM/TRZXRongIM/**/*.{h,m}"


    s.resources     = "TRZXRongIM/TRZXRongIM/**/*.{xib,storyboard}"
    s.resources     = "TRZXRongIM/TRZXRongIM/TRZXRongIM.bundle"
    s.requires_arc = true
    s.dependency "ReactiveCocoa", "~> 2.5"
    s.dependency "TRZXDIYRefresh"
    s.dependency "MJExtension"
    s.dependency "Masonry"
    s.dependency "SDWebImage"
    s.dependency "RongCloudIM", "~> 2.8.3"
    s.dependency "TRZXNetwork"
    s.dependency "TRZXKit"
    s.dependency "AMap3DMap"
    s.dependency "AMapSearch"
    s.dependency "AMapLocation"
    s.dependency "FMDB"
    s.dependency "TRZXLogin"
#    s.dependency "TRZXPersonalHome"
    s.dependency "TRZXPersonalJump"
    s.dependency "TRZXShare"
    s.dependency "TRZXInvestorDetail"
    s.dependency "TRZXInvestorDetailCategory"
    s.dependency "TRZXMSSBrowse"
    s.dependency "TRZXWebView"
    s.dependency "TRZXWebViewCategory"
    s.dependency "TRZXProjectDetailCategory"
    s.dependency "TRZXProject"
    s.dependency "TRZXComplaint"
    s.dependency "TRZXFriendCircle"
end