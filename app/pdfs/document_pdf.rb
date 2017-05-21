class DocumentPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include Prawn::Measurements

  DEFAULT_FONT = 'Times-Roman'
  DOCUMENT_DATA_HEIGHT = 45
  DOCUMENT_CONDITIONS  = 30
  HEADER_HEIGHT = 100
  FOOTER_HEIGHT = 150
  SECTION_MARGIN = 15

  def initialize(current_user, customer)
    super()

    @current_user = current_user
    @customer = customer

    repeat :all do
      generate_header
      generate_footer
    end

    generate_body
  end

  def generate_header
    if @current_user.logo.present?
      image @current_user.logo.path(:medium), at: bounds.top_left, fit: [75, 25]
    end

    bounding_box([0, header_top], width: header_width, height: HEADER_HEIGHT + DOCUMENT_DATA_HEIGHT + DOCUMENT_CONDITIONS) do
      document_data
      user_data
      customer_data
      document_conditions
    end
  end

  def document_data
    bounding_box([0, header_top], width: header_width, height: DOCUMENT_DATA_HEIGHT) do
      document_details
    end
  end

  def user_data
    bounding_box([header_block_left(0), bounds.top - DOCUMENT_DATA_HEIGHT], width: header_block_width, height: HEADER_HEIGHT) do
      font DEFAULT_FONT, style: :bold
      font_size 14

      move_down 10
      indent 10 do
        text @current_user[:name]

        font DEFAULT_FONT, style: :normal
        text @current_user[:tax_id]

        font_size 12
        text @current_user[:address]
        text "#{ @current_user[:city] }, #{ @current_user[:state] } #{ @current_user[:postal_code ]} (#{ @current_user.country_name })"

        unless @current_user[:phone_number].blank?
          text @current_user[:phone_number]
        end

        text @current_user[:email]
      end

      transparent(1) { stroke_bounds }
    end
  end

  def customer_data
    bounding_box([header_block_left(1), bounds.top - DOCUMENT_DATA_HEIGHT], width: header_block_width, height: HEADER_HEIGHT) do
      font DEFAULT_FONT, style: :bold
      font_size 14

      move_down 10
      indent 10 do
        text @customer[:name]

        font DEFAULT_FONT, style: :normal
        text @customer[:tax_id]

        font_size 12
        text @customer[:address]
        text "#{ @customer[:city] }, #{ @customer[:state] } #{ @customer[:postal_code ]} (#{ @customer.country_name })"

        unless @customer[:phone_number].blank?
          text @customer[:phone_number]
        end

        text @customer[:email]
      end

      transparent(1) { stroke_bounds }
    end
  end

  def document_conditions
    bounding_box([0, bounds.top - DOCUMENT_DATA_HEIGHT - HEADER_HEIGHT], width: header_width, height: DOCUMENT_CONDITIONS) do
      compose_document_conditions

      transparent(1) { stroke_bounds }
    end
  end

  def compose_document_conditions
    text "Document conditions"
  end

  def document_details
    text "define your own document_details method."
    transparent (0.5) { stroke_bounds }
  end

  def header_block_width
    header_width / 2
  end

  def header_block_left (index)
    header_block_width * index
  end

  def header_top
    bounds.top
  end

  def header_width
    bounds.right
  end

  def generate_footer
    bounding_box([0, footer_top], width: footer_width, height: FOOTER_HEIGHT) do
      generate_footer_notes
      generate_footer_totals
    end
  end

  def footer_top
    bounds.top - HEADER_HEIGHT - DOCUMENT_DATA_HEIGHT - DOCUMENT_CONDITIONS - SECTION_MARGIN - body_height - SECTION_MARGIN
  end

  def footer_width
    bounds.right
  end

  def generate_footer_notes
    bounding_box([0, bounds.top], width: footer_width * 0.66, height: FOOTER_HEIGHT) do
      footer_notes
    end
  end

  def footer_notes
  end

  def generate_footer_totals
    bounding_box([footer_width * 0.66, bounds.top], width: footer_totals_width, height: FOOTER_HEIGHT) do
      footer_totals
    end
  end

  def footer_totals_width
    footer_width * 0.33
  end

  def footer_totals
    text 'footer totals'
    transparent (0.5) { stroke_bounds }
  end

  def generate_body
    bounding_box([0, body_top], width: body_width, height: body_height) do
      body_details
    end
  end

  def body_details
    text 'body'
    start_new_page
    text 'body 2'
    transparent (0.5) { stroke_bounds }
  end

  def body_top
    bounds.top - HEADER_HEIGHT - DOCUMENT_CONDITIONS - DOCUMENT_DATA_HEIGHT - SECTION_MARGIN
  end

  def body_width
    bounds.right
  end

  def body_height
    bounds.top - HEADER_HEIGHT - DOCUMENT_CONDITIONS - DOCUMENT_DATA_HEIGHT - FOOTER_HEIGHT - SECTION_MARGIN * 2
  end

  def header_cell(text, borders, padding, align = 'left'.to_sym)
    cell = make_cell(content: text, borders: borders, padding: padding, align: align)
    cell.font_style = :bold

    cell
  end

  def data_cell(text, borders, padding, align = 'left'.to_sym)
    make_cell(content: text, borders: borders, padding: padding, align: align)
  end

  def currency_symbol(user)
    currency_code = user.try(:currency)
    currency = ISO4217::Currency.from_code(currency_code) unless currency_code.blank?
    currency.try(:symbol)
  end
end