# frozen_string_literal: true

module HasDocumentNumber
  extend ActiveSupport::Concern

  included do
    def number_valid?(date)
      return false if number.blank?

      parts = number_parts

      return false if parts.nil?
      return false if !date.nil? && (date.year != parts[:year])

      true
    end

    def number_parts
      return nil if number.blank?

      parts = number.match(%r(^([A-Z]+)\/(\d{4})\/(\d{6})$))
      return nil unless parts

      {
        serie: parts.captures[0],
        year: parts.captures[1].to_i,
        sequence: parts.captures[2].to_i
      }
    end
  end
end
