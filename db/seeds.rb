Author.find_or_create_by(name: 'Carl', email: 'carl@kisi.io')

author = Author.find_by_name('Carl')

subscribers_list = [ [ 'Rajat', 'rajat.usict@gmail.com' ], [ 'Christina', 'christina.schmid@getkisi.com' ] ]

subscribers_list.each do |name, email|
  author.subscribers.find_or_create_by(name: name, email: email)
end
