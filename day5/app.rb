require 'sinatra'
require 'sinatra/reloader'
require 'csv'

get '/' do
    erb :index
end


get '/board/new' do
    erb :new_board
end

get '/boards' do
    # 파일을 읽기모드로 열고 
    
    # 각 줄을 순회하면서
    # @가 붙어있는 변수에 넣어주자
   @boards = []
   CSV.open('./board.csv','r+').each do |row|
       @boards << row
    end
    erb :boards
end

post '/board/create' do
    # 사용자가 입력한 정보를 받아서
    # CSV 파일 가장 마지막에 등록
    # => 이 글의 글번호도 같이 저장해야한다.
    # => 기존의 글 개수를 파악해서
    # => 글 개수 +1 해서 저장
    ## 가장 현실적인 방법아늬겠뉘~?~?
    title = params[:title]
    contents =params[:contents]
    id = CSV.read('./board.csv').count + 1   #  id = CSV.open('./boards.csv','r').count
    puts [id,contents,title]
    CSV.open('./board.csv','a+') do |row|
        row << [id, title, contents]
    end
    redirect '/boards'
end

get '/board/:id' do
    # CSV파일에서 params[:id] 로 넘어온 친구와 같은 글번호를 가진 row를 선택.
    # => CSV파일을 전체 순회한다.그러다 첫번째 column이 아이디와 같은 값을 만나면
    # => 순회를 정지하고 값을 변수에 담아줍니다.
    @board = []
    CSV.read('./board.csv').each do |row|
        if row[0] == params[:id]          # if row[0].eql?(params[:id]) 
        @board = row
        break
        end
     end
    erb :board
end

get '/user/new' do
    erb :new_user

end

post '/user/create' do
    @user_id =[]
    CSV.open('./user.csv','r+').each do |user|
    @user_id << user[1]
    end
    if @user_id.include?(params[:user_id])
            erb :error
    elsif params[:password].eql? params[:password_confirmation]
        user_id = params[:user_id]
        password=params[:password]
        user_num = CSV.read('./user.csv').count + 1
        puts [user_num, user_id, password]
        CSV.open('./user.csv','a+') do |row|
            row << [user_num, user_id, password]
        end
        puts user_id
    redirect "/user/#{user_id}"
    else
        erb :error
    end
end

get '/user/:user_id' do
    @user = []
    CSV.open('./user.csv','r+').each do |row|
        if row[1] == params[:user_id]
            @user = row
        break
        end
    end
    erb :user
end

get '/users' do
    @users = []
    CSV.open('./user.csv','r+').each do |row|
        @users << row
    end
    erb :users
end