require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require 'json'

get '/menu' do

    menu = ["20층","순남시래기","양자강","김밥까페","컵라면"]
    new_menu = menu.sample(2)
    
    lunch = new_menu[0]
    dinner =new_menu[1]
    "점심에는 "+lunch+"을 먹고 저녁에는 "+ dinner+"을 드세요"

end

get '/lotto' do
 
    num = *(1..45)
    result = num.sample(6).sort
    "이번주 추천 로또 숫자는"+result.to_s+"입니다"

end

get '/check_lotto' do
    url = "http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    lotto = HTTParty.get(url)
    result = JSON.parse(lotto)
    numbers = []    # 빈배열
    bonus = result["bnusNo"]
    result.each do |k, v|
        if k.include?("drwtNo")
            numbers << v # value를 numbers 에 넣는 표시
        end
    end
     
    my_num = *(1..45)
    my_lotto = my_num.sample(6).sort
    
    count = 0
    numbers.each do |num|
        count += 1 if my_lotto.include?(num)
    end
   # puts "당첨갯수는 "+ count.to_s    
    if count == 3
         "5등 입니다."
    elsif count == 4
     "4등 입니다."
    elsif count == 5
        if my_lotto.include?("bonus")
             "2등 입니다."
        else  "3등 입니다."
        end
    elsif count == 6
     "1등 입니다. 축하합니다."
    else 
     count.to_s + " 개 당첨입니다."
        
    end
end


get '/kospi' do

response = HTTParty.get("http://finance.daum.net/quote/kospi.daum?nil_stock=refresh")
kospi = Nokogiri::HTML(response)
result = kospi.css("#hyenCost > b")
result.text
    
end

get '/html' do
    
    "<html>
        <head></head>
        <body>
        <h1>안녕하세요? 저는 <%=name %> 입니다.<H1> 
        </body>
    </html>"

end

get '/html_file' do
    @name = params[:name]
    name = "hoho"
    # send_file 'views/my_first_html.html' <- 얘는 html을 보내는거니까~!
    # send_file 'my_first_html.html' # 시나트라를 기준으로 파일을 찾기 때문에 찾지못함.
    erb :my_first_html      # : symbol(심벌) ~ 상징 == 얘 자체가 변수
end

get '/calculate' do
    num1 = params[:num1].to_i
    num2 = params[:num2].to_i

    @add = num1 + num2
    @minus = num1 - num2
    @mul = num1 * num2
    @div = num1 / num2
    
    
    erb :my_calculate
end