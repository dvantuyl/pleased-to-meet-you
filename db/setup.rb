require 'sequel'


DB = Sequel.connect('extralite://db/development.db')

DB.drop_table? :events

DB.create_table? :events do
  primary_key :id
  String :event
  String :data
  Integer :timestamp
end
