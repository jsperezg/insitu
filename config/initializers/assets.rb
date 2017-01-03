# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(_all-skins.css skin-blue.css)
Rails.application.config.assets.precompile += %w( estimates/edit_estimate_details.js )
Rails.application.config.assets.precompile += %w( delivery-notes/edit_delivery_note_details.js )
Rails.application.config.assets.precompile += %w( invoices/edit_invoice_details.js )

Rails.application.config.assets.precompile << /\.(?:gif|svg|eot|woff|ttf)\z/
