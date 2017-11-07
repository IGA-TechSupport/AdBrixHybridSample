/*
    AdBrix Hybrid Sample Javascript for Android and IOS.
*/

$(document).ready(function(){
    if (!jQuery) { throw new Error("Bootstrap requires jQuery") }
    
    var platform = "";
    commonUtils();

    $("#fte_call_btn").click(function (e) {
        var activity_name = $('#fte_call').find('input[name="fte_activity"]').val();
        console.log(activity_name);

        if(platform == 'aos'){
            window.Adbrix.firstTimeExperience(activity_name);
        }else if(platform == 'ios'){
            
            window.location = "adbrix://fte?activity="+activity_name;
        }else{
            platform = "unknown";
            alert("Only Support AOS and IOS OS, Please check OS platform");
            console.log("Only Support AOS and IOS OS, Please check OS platform");
            return;
        }        
    });

    $("#ret_call_btn").click(function (e) {
        var activity_name = $('#ret_call').find('input[name="ret_activity"]').val();
        console.log(activity_name);
        
        if(platform == 'aos'){
            window.Adbrix.retention(activity_name);
        }else if(platform == 'ios'){
            window.location = "adbrix://ret?activity="+activity_name;
        }else{
            alert("Only Support AOS and IOS OS, Please check OS platform");
            console.log("Only Support AOS and IOS OS, Please check OS platform");
            return;
        }        
    });

    $("#purchase_call_btn").click(function () {
        /*
        String orderId, 
        String productId, 
        String productName, 
        double price, 
        int quantity, 
        String currencyCode, 
        String category
        */
        var oid = $('#purchase_call').find('input[name="oid"]').val();
        var pid = $('#purchase_call').find('input[name="pid"]').val();
        var pname = $('#purchase_call').find('input[name="pname"]').val();
        var price = $('#purchase_call').find('input[name="price"]').val();
        var quantity = $('#purchase_call').find('input[name="quantity"]').val();
        var currencyCode = $('#purchase_call').find('input[name="currencyCode"]').val();
        var category = $('#purchase_call').find('input[name="category"]').val();

        console.log("purchase event!!");

        if(platform == 'aos'){
            window.Adbrix.purchase(oid, pid, pname, price, quantity, currencyCode, category);
        }else if(platform == 'ios'){
            window.location = "adbrix://purchase?oid={0}&pid={1}&pname={2}&price={3}&quantity={4}&currency_code={5}&category={6}".format(oid, pid, pname, price, quantity, currencyCode, category);
        }else{
            alert("Only Support AOS and IOS OS, Please check OS platform");
            console.log("Only Support AOS and IOS OS, Please check OS platform");
            return;
        }
    });

    function commonUtils(){
        // 모바일 에이전트 구분
        var isMobile = {
            Android: function () {
                return navigator.userAgent.match(/Android/i) == null ? false : true;
            },
            IOS: function () {
                return navigator.userAgent.match(/iPhone|iPad|iPod/i) == null ? false : true;
            },
            any: function () {
                return (isMobile.Android() || isMobile.IOS());
            }
        };

        if(isMobile.any()){
            if(isMobile.Android()){
                platform = "aos";
                console.log("AOS BROWSER DETECTED!");
            }else if(isMobile.IOS()){
                platform = "ios";            
                console.log("IOS BROWSER DETECTED!");
            }else{
                platform = "unknown";
                alert("Only Support AOS and IOS OS, Please check OS platform");
                console.log("Only Support AOS and IOS OS, Please check OS platform");
            }            
        }  
        
        // string builder
        if (!String.prototype.format) {
            String.prototype.format = function() {
                var args = arguments;
                return this.replace(/{(\d+)}/g, function(match, number) { 
                    return typeof args[number] != 'undefined'
                    ? args[number]
                    : match
                    ;
                });
            };
        }
    }

});
