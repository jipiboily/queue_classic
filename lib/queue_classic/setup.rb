module QC
  module Setup
    Root = File.expand_path("../..", File.dirname(__FILE__))
    SqlFunctions = File.join(Root, "/sql/ddl.sql")
    CreateTable = File.join(Root, "/sql/create_table.sql")
    DropSqlFunctions = File.join(Root, "/sql/drop_ddl.sql")
    AddHeartbeat = File.join(Root, "/sql/add_heartbeat.sql")
    RemoveHeartbeat = File.join(Root, "/sql/remove_heartbeat.sql")

    def self.create(c = QC::default_conn_adapter.connection)
      conn = QC::ConnAdapter.new(c)
      conn.execute(File.read(CreateTable))
      conn.execute(File.read(SqlFunctions))
      conn.execute(File.read(UpgradeTo_3_0_0))
      conn.disconnect if c.nil? #Don't close a conn we didn't create.
    end

    def self.drop(c = QC::default_conn_adapter.connection)
      conn = QC::ConnAdapter.new(c)
      conn.execute("DROP TABLE IF EXISTS queue_classic_jobs CASCADE")
      conn.execute(File.read(DropSqlFunctions))
      conn.disconnect if c.nil? #Don't close a conn we didn't create.
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
