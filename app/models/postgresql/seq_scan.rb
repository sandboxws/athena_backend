module Postgresql
  class SeqScan < ApplicationRecord
    self.table_name = 'pg_seq_scans'
  end
end
