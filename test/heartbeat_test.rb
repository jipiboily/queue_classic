require File.expand_path("../helper.rb", __FILE__)


class SlowWorker
  def self.meh
    connection = QC::ConnAdapter.new
    connection.connection.transaction do
      connection.execute("INSERT INTO #{QC::TABLE_NAME} (q_name, method, args) VALUES ('whatever', 'Kernel.puts', '[\"ok?\"]')")
      sleep 13
    end
  end
end

class HeartbeatTest < QCTest
  def test_heartbeat_update_with_a_transaction_running
    # Setup the task and worker
    QC.enqueue("SlowWorker.meh")
    assert_equal(1, QC.count)
    worker = QC::Worker.new
    worker.running = true
    Thread.new { worker.work }

    # Create a different connection so that we can see if the updated_at
    # is updated out of the transaction that is also inserting another
    # record that we should not see
    new_db_connection = QC::ConnAdapter.new.connection

    # Let's store the original updated_at value to compare after X time
    res = new_db_connection.exec("SELECT * FROM #{QC::TABLE_NAME} WHERE locked_by='#{worker.id}'")
    original_updated_at = res.first['updated_at']
    refute_nil(original_updated_at)

    # Wait a bit for a heartbeat to be sent
    sleep 11

    # Can we see the row that was inserted as part of the transaction?
    res = new_db_connection.exec("SELECT * FROM #{QC::TABLE_NAME} WHERE q_name='whatever'")
    assert_equal(res.count, 0) # We should not see it!

    # Was the updated_at, updated?
    res = new_db_connection.exec("SELECT * FROM #{QC::TABLE_NAME} WHERE locked_by='#{worker.id}'")
    refute_equal(res.first['updated_at'], original_updated_at) # yes, it was updated
  end
end
