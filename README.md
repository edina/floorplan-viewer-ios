

###Build documentation

```shell

$git clone https://github.com/edina/floorplan-viewer-ios.git

$cd floorplan-viewer-ios/

$cd FloorPlan/
```

Install the estimotes sdk via a CocoaPods install

check your pod env

```shell
$pod env
```

Should expect to get a similar env output to the following...


### Plugins


```

cocoapods-deintegrate : 1.0.0

cocoapods-plugins     : 1.0.0

cocoapods-search      : 1.0.0

cocoapods-stats       : 1.0.0

cocoapods-trunk       : 1.0.0

cocoapods-try         : 1.0.0

```


### Podfile


```ruby

platform :ios, '7.0'

target "Library Tour" do

   pod 'EstimoteSDK'

end

```
```shell
$pod install
```

###ISSUES

If there is a warning / error then comment this line out on

in this file CTiledScrollView/JCTiledScrollView/Source/JCTiledScrollView.m

```
//[CATransaction setValue:(id) kCFBooleanTrue forKey:kCATransactionDisableActions];
```





