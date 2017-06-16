# AdBrixHybridSample

### 애드브릭스 하이브리드 연동 가이드
본 가이드는 하이브리드 앱에서 애드브릭스 SDK를 호출하기 위한 Javascript Interface 구축을 설명합니다.  
애드브릭스를 연동하는데 필요한 기본적인 연동사항들은 [Help Center](http://help.igaworks.com)를 참고해주세요.

### 1. WEB PAGE
웹에서 발생한 이벤트 정보를 ANDROID NATIVE 로 전달하여야 합니다.  

~~~javascript
window.[name].[method](var param);
~~~

위와 같은 방식으로 호출하며, 예제에서는 다음과 같이 AdBrix retention api를 호출하였습니다.  

~~~javascript
window.Adbrix.retention("sample_data");
~~~

  
     

### 2. ANDROID NATIVE
웹에서 전달한 이벤트를 수신하여 적절한 AdBrix api를 호출합니다.  
webview 에 javascript interface 를 추가하여 위에서 호출하는 자바스크립트 이벤트를 캐치할 수 있습니다.

~~~java
    webView.addJavascriptInterface(adbrixHybridInterface, "Adbrix");
~~~

> 위 샘플코드의 "Adbrix" 는 자바스크립트의 window.[name].[method](param) 의 name과 반드시 동일해야 합니다.


