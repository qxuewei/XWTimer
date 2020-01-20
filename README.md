# XWTimer
 
A Simple GCD Timer with Objective-C.

### CocoaPod

```
pod 'XWTimer'
```

### How to use?
#### `target-selector`
```objc
self.timer = [XWTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) repeats:YES];

- (void)timerMethod
{
    /// do somethings
}
```

#### `block`

```objc
__weak typeof(self) weakSelf = self;
self.timer =[XWTimer timerWithTimeInterval:1.0 repeats:YES block:^(XWTimer * _Nonnull timer) {
    __strong typeof(weakSelf) strongSelf = weakSelf;
    /// do somethings
}];
```

#### Start

```objc
[self.timer fire];
```

#### Pause

```objc
[self.timer pause];
```

#### Invalidate

```objc
[self.timer invalidate];
```