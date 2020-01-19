Pod::Spec.new do |s|
s.name         = "XWTimer"
s.version      = "1.0.0"
s.summary      = "GCD Timer"
s.description  = <<-DESC
A Simple GCD Timer with Objective-C
DESC
s.homepage     = "https://github.com/qxuewei/XWTimer"
s.license      = "MIT"
s.author       = { "qxuewei" => "qxuewei@yeah.net" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/qxuewei/XWTimer.git", :tag => "#{s.version}" }
s.source_files  = "XWTimer/*"
end