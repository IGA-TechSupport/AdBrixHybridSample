package com.iga.adbrixhybridsamplev1;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;

import com.igaworks.IgawCommon;
import com.igaworks.adbrix.IgawAdbrix;
import com.igaworks.commerce.IgawCommerce;

public class MainActivity extends AppCompatActivity {

    final String HYBRID_SAMPLE_PAGE_URL = "http://integration.igaworks.com/adbrixHybrid";
    private WebView webView;

    @SuppressLint("JavascriptInterface")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        AdbrixHybridInterface adbrixHybridInterface;
        adbrixHybridInterface = new AdbrixHybridInterface(this);

        webView = (WebView)findViewById(R.id.webView);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.addJavascriptInterface(adbrixHybridInterface, "Adbrix");
        webView.setWebChromeClient(new WebChromeClient());
        webView.loadUrl(HYBRID_SAMPLE_PAGE_URL);

    }

    private class AdbrixHybridInterface {

        private Activity mContext;

        public AdbrixHybridInterface(Activity activity){
            mContext = activity;
        }


        /**
         * AdBrix FirstTimeExperience API 를 호출한다.
         * @param name : 유저 행동을 정의한 문자열
         * */
        @JavascriptInterface
        public void firstTimeExperience(String name){
            Log.d("ABX_HYBRID", "retention api called!!! /w " + name);
            IgawAdbrix.firstTimeExperience(name);
        }

        /**
         * AdBrix FirstTimeExperience API를 sub parameter 와 함께 호출한다.
         * @param name : 유저 행동을 정의한 문자열
         * @param param : 각 행동의 서브 파라미터
         * */
        @JavascriptInterface
        public void firstTimeExperienceWithParam(String name, String param){
            Log.d("ABX_HYBRID", "firstTimeExperienceWithParam api called!!!  /w " + name);
            IgawAdbrix.firstTimeExperience(name, param);

        }

        /**
         * AdBrix Retention API 를 호출한다.
         * @param name : 유저 행동을 정의한 문자열
         * */
        @JavascriptInterface
        public void retention(String name){
            Log.d("ABX_HYBRID", "retention api called!!! /w " + name );
            IgawAdbrix.retention(name);
        }

        /**
         * AdBrix Retetion API를 sub parameter 와 함께 호출한다.
         * @param name : 유저 행동을 정의한 문자열
         * @param param : 각 행동의 서브 파라미터
         * */
        @JavascriptInterface
        public void retentionWithParam(String name, String param){
            Log.d("ABX_HYBRID", "retentionWithParam api called!!!  /w " + name);
                    IgawAdbrix.retention(name, param);

        }

        /**
         * AdBrix Commerce purchase api를 호출한다.
         * @param orderId : 주문번호
         * @param productId : 제품번호
         * @param productName : 상품명
         * @param price : 상품 단가
         * @param quantity : 구매 수량
         * @param currencyCode : 상품 구매 통화 단위
         * @param category : 상품 카테고리 정보
         * */
        @JavascriptInterface
        public void purchase(String orderId, String productId, String productName, String price, String quantity, String currencyCode, String category) {
            Log.d("IGAW_SAMPLE", "purchase api called!!!");
            Log.d("IGAW_SAMPLE", "orderId : " + orderId +
                    "/n productId : " + productId +
                    "/n productName : " + productName +
                    "/n price : " + price +
                    "/n quantity : " + quantity +
                    "/n currencyCode : " + currencyCode +
                    "/n category : " + category);

            double castedPrice = 0;
            int castedQunaity = 0;
            try {
                castedPrice = Double.parseDouble(price);
                castedQunaity = Integer.parseInt(quantity);
            }catch (Exception e){
                Log.e("IGAW_SAMPLE", "parameter casting error /w " + e.getMessage());
                Log.e("IGAW_SAMPLE", "wrong parameter will be setted as 0");
            }
            IgawCommerce.purchase(mContext, orderId, productId, productName, castedPrice, castedQunaity, IgawCommerce.Currency.getCurrencyByCountryCode(currencyCode), category);
        }

    }

    @Override
    protected void onResume() {
        super.onResume();
        IgawCommon.startSession(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        IgawCommon.endSession();
    }
}
