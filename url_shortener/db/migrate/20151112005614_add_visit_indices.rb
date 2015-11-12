class AddVisitIndices < ActiveRecord::Migration
  add_index(:visits, :visitor_id)
  add_index(:visits, :shortened_url_id)
end
