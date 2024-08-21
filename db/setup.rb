require 'sequel'


DB = Sequel.connect(adapter: 'extralite', database: './db/development.db', wal: true)

DB.drop_table? :events

DB.create_table? :events do
  primary_key :id
  String :type
  String :entity
  String :message
  Integer :timestamp
end

[1,2].each do |id|
  db = Sequel.connect(adapter: 'extralite', database: "./db/agent-#{id}.db", wal: true)
  db.drop_table? :memories

  db.create_table? :memories do
    primary_key :id
    String :entity
    String :memory
    Integer :timestamp
  end
end
