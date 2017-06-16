/*
    AdBrix Hybrid Sample Javascript for Android.
*/


if (!jQuery) { throw new Error("Bootstrap requires jQuery") }


$("#fte_call_btn").click(function (e) {
    var activity_name = $('#fte_call').find('input[name="fte_activity"]').val();
    window.Adbrix.firstTimeExperience(activity_name);
    console.log(activity_name);
});

$("#ret_call_btn").click(function(e){
    var activity_name = $('#ret_call').find('input[name="ret_activity"]').val();
    window.Adbrix.retention(activity_name);
    console.log(activity_name);
});

$("#purchase_call_btn").click(function(){
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
    var currencyCode= $('#purchase_call').find('input[name="currencyCode"]').val();
    var category = $('#purchase_call').find('input[name="category"]').val();
    
    alert("price : " + price + "  quantity : " + quantity);

    window.Adbrix.purchase(oid, pid, pname, price, quantity, currencyCode, category);
    
});
  
