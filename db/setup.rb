require 'sequel'


DB = Sequel.connect(adapter: 'extralite', database: './db/development.db', wal: true)

DB.drop_table? :events
DB.drop_table? :agents

DB.create_table? :events do
  primary_key :id
  String :type
  String :entity
  String :message
  Integer :timestamp
end
