require 'sequel'


DB = Sequel.connect('extralite://db/development.db')

DB.drop_table? :events
DB.drop_table? :agents

DB.create_table? :events do
  primary_key :id
  String :type
  String :entity
  String :message
  Integer :timestamp
end
