module Para
  module SeoTools
    class PageSearchAnalyticsRow < ActiveRecord::Base
      belongs_to :page

      validates :page_id, uniqueness: { scope: [:country, :query, :device, :date] }
      validates :page, :country, :query, :device, presence: true
    end
  end
end
