# LestSlideMenu

## 一个模仿现版本QQ的左滑抽屉效果.
```swift
self.window?.rootViewController =  
LeftSlideMenu(leftViewController:
             UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!, 
             mainViewController: 
             UIStoryboard(name: "Root", bundle: Bundle.main).instantiateInitialViewController()!)
```

