require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require 'rest-client'
require 'csv'

get '/' do

    erb:index
end

get '/webtoon' do
    # 내가 받아온 웹툰 데이터를 저장할 배열 생성
    toons = []
    # 웹툰 데이터를 받아올 url을 파악 및 요청 보내기
    url = "http://webtoon.daum.net/data/pc/webtoon/list_serialized/mon" # data요청
    result = RestClient.get(url) # 해당 url의 요청 방식이 get이기 때문에
    
    # 응답으로 온 내용을 해쉬형태로 바꾸기
    webtoons = JSON.parse(result)
    # 해쉬에서 웹툰 리스트에 해당하는 부분 순환하기
    webtoons["data"].each do |toon|
    	# 웹툰 제목
        title = toon["title"]
        # 웹툰 이미지 주소
        image = toon["thumbnailImage2"]["url"]
        # 웹툰을 볼수있는 주소
        link = "http://webtoon.daum.net/webtoon/view/#{toon['nickname']}" # String interpolation
         # 필요한 부분을 분리해서 처음 만든 배열에 push
        toons << { "title" => title,
                  "image" => image,
                  "link" => link
        }
    end
    # 완성된 배열 중에서 3개의 웹툰만 랜덤 추출
    @daum_webtoon = toons.sample(3)
    erb :webtoon # 뷰생성
end



get '/check_file' do
    unless File.file?('./test.csv') #if not에 해당 ==> unless : if 에서 false가 나와야 조건문 실행된다.
        puts "파일이 없습니다."

        toons = []
        url = "http://webtoon.daum.net/data/pc/webtoon/list_serialized/mon" # data요청
        result = RestClient.get(url) # 해당 url의 요청 방식이 get이기 때문에
        webtoons = JSON.parse(result)
        webtoons["data"].each do |toon|
                title = toon["title"]
                image = toon["thumbnailImage2"]["url"]
                link = "http://webtoon.daum.net/webtoon/view/#{toon['nickname']}"
                toons << [title,image,link]
        end
        # CSV 파일을 새로 생성하는 코드
        CSV.open('./test.csv','w+') do |row|
            # 크롤링한 웹툰 데이터를 CSV에 삽입

           toons.each_with_index do |toon, index| # 인덱스를 같이 돌려줘라,
               row << [index+1 , toon[0],toon[1],toon[2]]
           end
       end

        erb :check_file
    else
        # 존재하는 CSV파일을 불러오는 코드
        @webtoons = []
        CSV.open('./test.csv','r+').each do |row|
            @webtoons << row
        end
    puts @webtoons
    erb :webtoons

    end
end

get '/board/:name' do
    puts params[:name]
end
