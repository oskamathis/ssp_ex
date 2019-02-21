# miniSSP課題

## 要件
1. SDKからリクエストを受けて、広告を返す
2. 複数のDSPに対して、AdRequestを投げ、AdResponseを受け取る
3. 一番高い入札を行ったDSPに対して、WinNoticeを送り、2ndPriceをつけて送る
4. 入札時間は、Requestを送ってから100ms以内とする
5. すべてのDSPからのレスポンスを得られなかった場合、自社広告をSDKに対して返す
6. レスポンスが1つしか得られなかった場合、2ndプライスを1円として、WinNoticeを返す


## API仕様
### SDK-SSP
#### Request
```
{
    "app_id": 123
}
```
#### Response
```
{
    "url": "http://example.com/ad/image/123"
}
```

### SSP-DSP
#### Request
```
{
    "ssp_name": "y_sako",
    "request_time": "yyyymmdd-HHMMSS.ssss",
    "request_id": "<SSP-Name>-UUID",
    "app_id": 123
}
```

#### Response
```
{
    "request_id": "<SSP-Name>-UUID",
    "url": "http://example.com/ad/image/123",
    "price": 50
}
```

#### WinNotice
```
{
    "request_id": "<SSP-Name>-UUID",
    "price": 35
}
```

#### WinResponse
```
{
    "result": "ok"
}
```


## EndPoint
### SSP
- AdRequest: http://ssp1.example.jp/req

### DSP
- AdRequest: http://dsp1.example.jp/req
- WinNotice: http://dsp1.example.jp/win
