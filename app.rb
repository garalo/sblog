require 'sinatra'
require 'json'

# Blog yazılarını yüklemek için
def load_blog_posts
  posts = []
  Dir.glob('data/posts/*.json') do |file|
    post = JSON.parse(File.read(file))
    post['id'] = File.basename(file, '.json') # Dosya adını ID olarak ekle
    posts << post
  end
  #puts posts.inspect # Hata ayıklama için loglama
  posts
end

get '/' do
  @blog_posts = load_blog_posts
  erb :home
end

get '/about' do
  erb :about
end

get '/blog' do
  @blog_posts = load_blog_posts
  erb :blog_list #bu syfada blog yazıları listeliyor olacaktır.
end

get '/contact' do
  erb :contact
end

get '/blog/:id' do
  file_path = "data/posts/#{params[:id]}.json"
  if File.exist?(file_path)
    @post = JSON.parse(File.read(file_path))

    # content alanındaki dosyadan içeriği oku
    if @post['content'].end_with?('.txt')
      @post['content'] = File.read("data/posts/#{@post['content']}", encoding: "UTF-8")
    end

    erb :blog
  else
    status 404
    "Blog yazısı bulunamadı."
  end
end
