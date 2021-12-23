class EcpayController < ApplicationController
    before_action :autenticate_spa_user! ,only:[:payByECPay]


    def ecpayReturn
        tid=params[:MerchantTradeNo].slice(12..)
        trade=Trade.find_by(id: tid)

        if params[:RtnCode]=="1"
            trade.paid!
            render text: "1|OK"
        else
            trade.fail!
            render text: ""

        end

    end

    def ecpayClientPage
        # tid=params[:MerchantTradeNo].slice(12..)

        if params[:RtnCode]=="1"
            render html:"<h1>Success</h1>".html_safe
        else
            render html:"<h1>Fail #{params[:RtnMsg]}</h1>".html_safe
        end
    end

    # {
    #     "trade":1  #trade id
    # }
    def payByECPay

        tid=params[:trade]
        trade=Trade.eager_load(carts: :product).find_by(id: tid,user_id: @user[:id])

        items=""
        trade.carts.each_with_index do |cart,i|
            tmpP=cart.product
            if i!=0
                items.concat "#"
            end
            items.concat "#{tmpP[:name]} #{tmpP[:price]}元*#{cart[:amount]}"
        end
        
        time=Time.new.getlocal('+08:00')
        
        trade_no=time.strftime("NO%y%m%d%H%M")+trade[:id].to_s  # NO+strftime (len 12)+trade[id]
        trade[:trade_no]=trade_no

        ## 參數值為[PLEASE MODIFY]者，請在每次測試時給予獨特值
        ## 若要測試非必帶參數請將base_param內註解的參數依需求取消註解 ##

        base_param = {
            'MerchantTradeNo' =>trade_no,  #請帶20碼uid, ex: f0a0d7e9fae1bb72bc93
            'MerchantTradeDate' => time.strftime("%Y/%m/%d %H:%M:%S"), # ex: 2017/02/13 15:45:30
            'TotalAmount' => trade[:total_price],
            'PaymentType'=>'aio',
            'TradeDesc' => 'shopping-api',
            'ItemName' => items,
            'ReturnURL' => request.base_url+'/ecpay/ecpayReturn',
            'ChooseSubPayment' => 'ALL',
            'OrderResultURL' => request.base_url+'/ecapy/ecpayClientPage',
            #'NeedExtraPaidInfo' => '1',
            #'ClientBackURL' => 'https://www.google.com',
            #'ItemURL' => 'http://item.test.tw',
            # 'Remark' => '交易備註',
            #'StoreID' => '',
            #'CustomField1' => '',
            #'CustomField2' => '',
            #'CustomField3' => '',
            #'CustomField4' => ''
        }
    
    
        ## 若要測試開立電子發票，請將inv_params內的"所有"參數取消註解 ##
        inv_params = {
=begin
        'RelateNumber' => 'PLEASE MODIFY',  #請帶30碼uid ex: SJDFJGH24FJIL97G73653XM0VOMS4K
        'CustomerID' => 'MEM_0000001',  #會員編號
        'CustomerIdentifier' => '',   #統一編號
        'CustomerName' => '測試買家',
        'CustomerAddr' => '測試用地址',
        'CustomerPhone' => '0123456789',
        'CustomerEmail' => 'johndoe@test.com',
        'ClearanceMark' => '2',
        'TaxType' => '1',
        'CarruerType' => '',
        'CarruerNum' => '',
        'Donation' => '2',
        'LoveCode' => '',
        'Print' => '1',
        'InvoiceItemName' => '測試商品1|測試商品2',
        'InvoiceItemCount' => '2|3',
        'InvoiceItemWord' => '個|包',
        'InvoiceItemPrice' => '35|10',
        'InvoiceItemTaxType' => '1|1',
        'InvoiceRemark' => '測試商品1的說明|測試商品2的說明',
        'DelayDay' => '0',
        'InvType' => '07'
=end
        }
       
        create = ECpayPayment::ECpayPaymentClient.new
        htm = create.aio_check_out_all(params: base_param, invoice: inv_params)

        if htm
            trade.paying!
        else
            trade.fail!
        end

        render plain: htm
    end
end
