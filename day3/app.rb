require 'sinatra'
require 'sinatra/reloader'
require 'uri'
require 'httparty'
require 'nokogiri'
require 'rest-client'

get '/' do
    erb :app
end 

get '/calculate' do
   num1 = params[:n1].to_i
   num2 = params[:n2].to_i
   @sum = num1 + num2
   @min = num1 - num2
   @mul = num1 * num2
   @div = num1 / num2
   
   erb :calculate
end

get '/numbers' do
    erb :numbers
end

get '/form' do
    erb :form
end



post '/login' do    # post요청을 받도록 앞에 post명시
    id = "multi"
    pw="campus"
    if id.eql?(params[:id])
        # 비밀번호 체크 로직
        if pw.eql?(params[:password])
        else 
            @msg = "비밀번호가 틀립니다."
            #인스턴스 변수이기 때문에 이 블럭 안에서만 살아있기 때문 & MVC는 한바퀴돌면 connection이 끊어지기 때문에 위의 msg는 보이지 않음.
            redirect '/error?err_code=1'
        end
    else
        # ID가 존재하지 않습니다.
        @msg="아이디가 존재하지 않습니다."
        redirect '/error?err_code=2'
    end
end

# 계정이 존재하지않거나 비밀번호가 틀린경우
get '/error' do
    # 다른 방식으로 에러메세지를 보여줘야 합니당.

    #id 가 없는 경우
    if params[:err_code].to_i ==2
        @msg="id가 없습니다."
    #pw 가 틀린 경우
    elsif params[:err_code].to_i ==1    
        @msg="비밀번호가 틀립니다."
    end
 erb :error
end

# 로그인 완료된 곳
get '/complete' do
    erb :complete
end

get '/search' do
    erb :search
end

post '/search' do
    puts params[:engine]
    case params[:engine]
    when "naver"
        url=URI.encode("https://search.naver.com/search.naver?query=#{params[:query]}")
        redirect url
    when "google"
        url=URI.encode("https://www.google.com/search?q=#{params[:q]}")
        redirect url
    end
end

get '/op_gg' do
    erb:op_gg
end


post '/op_gg' do
    if params[:userName] # nil 때문이라는데 이거 이해못함^^;
        case params[:search_method]
        when "opgg"
            url=URI.encode("http://www.op.gg/summoner/userName=#{params[:userName]}")
            redirect url
        when "self"
            url = RestClient.get(URI.encode("http://www.op.gg/summoner/userName=#{params[:userName]}"))
            result = Nokogiri::HTML.parse(url)

            if result.css("span.total").size > 0
             total=result.css("span.total")
              win=result.css("span.win").first
              lose=result.css("span.lose")[0]
                
              @total=total.text
              @win = win.text
              @lose = lose.text
                 erb:op_gg
            else 
                @msg = "이 아이디는 없다거ㅠㅠㅠ엉어어어엉엉"
                 erb:op_gg
            end
        end
    end
    erb:op_gg
end
