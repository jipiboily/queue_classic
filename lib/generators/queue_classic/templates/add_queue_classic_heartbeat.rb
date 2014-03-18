class AddQueueClassicHeartbeat < ActiveRecord::Migration
  def self.up
    QC::Setup.add_heartbeat
  end

  def self.down
    QC::Setup.remove_heartbeat
  end
end
