module Postgresql
  class DmlStat < ApplicationRecord
    self.table_name = 'pg_dml_stats'
  end
end
