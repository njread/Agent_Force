curl --location 'https://login.salesforce.com/services/oauth2/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Cookie: BrowserId=qsN4dBcPEe-CdAPEIJOVQg; CookieConsentPolicy=0:0; LSKey-c$CookieConsentPolicy=0:0' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'client_id=3MVG9bYGb9rFSjxTSZw3Wzu7jaPdqozqK1uSKc0IPkLOI4eSA3xe7lrijrRG2GcOT18Xj8I8nx0dAQxAovME6' \
--data-urlencode 'client_secret=6B81B31973A95EAA5549EAC7E433BEF2801BF36DAAA32E802ECF190F15FDADB4' \
--data-urlencode 'username=nread@data-box-partner.com' \
--data-urlencode 'password=BoxRocks2024!!'


curl --location 'https://data-box-partner-dev-ed.develop.my.salesforce.com/services/a360/token' \
--header 'Authorization: Bearer 00Dam00000517wP!AQEAQP8ZKEc0Sm.DY3P2rMrliOKELRfAdeLcq71uHO3tFUsHqqALnpIywt.PTF.3WmsPCQSCuISy8yfLk3NE_0_IgVSIl8am' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--header 'Cookie: BrowserId=qsN4dBcPEe-CdAPEIJOVQg; CookieConsentPolicy=0:1; LSKey-c$CookieConsentPolicy=0:1' \
--data-urlencode 'grant_type=urn:salesforce:grant-type:external:cdp' \
--data-urlencode 'subject_token=00Dam00000517wP!AQEAQGAA526kstruqvOLBmmE_hatuFnTidLcOTj_X9E8l_cGyFnBqnLwVuGbMkUszzK08z_8fsuh_BDc5XQm3s.GpeQJC9Sw' \
--data-urlencode 'subject_token_type=urn:ietf:params:oauth:token-type:access_token'