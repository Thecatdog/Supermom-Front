require 'mongo'

# mongo driver
Mongo::Logger.logger.level = Logger::FATAL

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')

client.collections.each { |coll| puts coll.name }

client.close

# client_host = ['syd-mongos0.objectrocket.com:12345']
# client_options = {
#   database: 'YOUR_DATABASE',
#   user: 'YOUR_USERNAME',
#   password: 'YOUR_PASSWORD',
#   write: { w: 1 }
# }

# begin
#   client = Mongo::Client.new(client_host, client_options)
#   puts('Client Connection: ')
#   puts(client.cluster.inspect)
#   puts
# #   puts('Collection Names: ')
# #   puts(client.database.collection_names)
# #   puts('Connected!')
#     client.collections.each { |coll| puts coll.name }

#   client.close
# rescue StandardError => err
#   puts('Error: ')
#   puts(err)
# end