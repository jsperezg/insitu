class FixRails5Migration < ActiveRecord::Migration[5.0]
  def change
    begin
      execute "CREATE TABLE `ar_internal_metadata` (
        `key` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
        `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `created_at` datetime NOT NULL,
        `updated_at` datetime NOT NULL,
        PRIMARY KEY (`key`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
    rescue => e
      puts e
    end
  end
end
