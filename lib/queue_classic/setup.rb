module QC
  module Setup
    Root = File.expand_path("../..", File.dirname(__FILE__))
    SqlFunctions = File.join(Root, "/sql/ddl.sql")
    CreateTable = File.join(Root, "/sql/create_table.sql")
    DropSqlFunctions = File.join(Root, "/sql/drop_ddl.sql")
    AddHeartbeat = File.join(Root, "/sql/add_heartbeat.sql")
    RemoveHeartbeat = File.join(Root, "/sql/remove_heartbeat.sql")

    def self.create
      Conn.execute(File.read(CreateTable))
      Conn.execute(File.read(SqlFunctions))
      Conn.execute(File.read(AddHeartbeat))
    end

    def self.drop
      Conn.execute("DROP TABLE IF EXISTS queue_classic_jobs CASCADE")
      Conn.execute(File.read(DropSqlFunctions))
    end

    def self.update
      Conn.execute(File.read(AddHeartbeat))
    end

    def self.add_heartbeat
      Conn.execute(File.read(AddHeartbeat))
    end

    def self.remove_heartbeat
      Conn.execute(File.read(RemoveHeartbeat))
    end
  end
end
