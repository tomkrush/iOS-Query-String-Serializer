# iOS-Query-Var-Serializer


I created this class because I couldn’t find an existing solution that would create nested query strings using Objective-C.


TODO: 
- Test more thoroughly
- Documentation
- Make sure code produces errors if serializer fails

``` Objective-C

NSDictionary *data = @{
    @"languages": @[
        @"Objective-C",
        @"C",
        @"Ruby",
        @"Python"
        @"Javascript"
    ],
    @"todos": @[
        @"Sample Task",
        @"Another Sample Task"
    ]
};

NSString *queryString = [KRSQueryDataSerializer stringFromDictionary:data];
    
NSLog(@"%@", queryString);
```

### Output

```
todos[0]=Sample%20Task&todos[1]=Another%20Sample%20Task&languages[0]=Objective-C&languages[1]=C&languages[2]=Ruby&languages[3]=PythonJavascript
```
