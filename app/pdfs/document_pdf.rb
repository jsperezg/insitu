class DocumentPdf < Prawn::Document
  DEFAULT_FONT = 'Times-Roman'
  HEADER_HEIGHT = 100
  FOOTER_HEIGHT = 150
  SECTION_MARGIN = 5

  def initialize(current_user, customer)
    super()

    @current_user = current_user
    @customer = customer

    generate_header
    generate_body
    generate_footer
  end

  def generate_header
    bounding_box([0, header_top], width: header_width, height: HEADER_HEIGHT) do
      user_data
      customer_data
      document_data
    end
  end

  def user_data
    bounding_box([header_block_left(0), bounds.top], width: header_block_width, height: HEADER_HEIGHT) do
      font DEFAULT_FONT, style: :bold
      font_size 12

      text @current_user[:name]

      font DEFAULT_FONT, style: :normal
      text @current_user[:tax_id]

      font_size 8
      text @current_user[:address]
      text "#{ @current_user[:city] }, #{ @current_user[:state] } #{ @current_user[:postal_code ]} (#{ @current_user.country_name })"

      unless @current_user[:phone_number].blank?
        text @current_user[:phone_number]
      end

      text @current_user[:email]
    end
  end

  def customer_data
    bounding_box([header_block_left(1), bounds.top], width: header_block_width, height: HEADER_HEIGHT) do
      font DEFAULT_FONT, style: :bold
      font_size 12

      text @customer[:name]

      font DEFAULT_FONT, style: :normal
      text @customer[:tax_id]

      font_size 8
      text @customer[:address]
      text "#{ @customer[:city] }, #{ @customer[:state] } #{ @customer[:postal_code ]} (#{ @customer.country_name })"

      unless @customer[:phone_number].blank?
        text @customer[:phone_number]
      end

      text @customer[:email]
    end
  end

  def document_data
    bounding_box([header_block_left(2), bounds.top], width: header_block_width, height: HEADER_HEIGHT) do
      document_details
    end
  end

  def document_details
    text "define your own document_details method."
    transparent (0.5) { stroke_bounds }
  end

  def header_block_width
    (header_width - SECTION_MARGIN * 2) / 3
  end

  def header_block_left (index)
    (header_block_width + SECTION_MARGIN) * index
  end

  def header_top
    bounds.top
  end

  def header_width
    bounds.right
  end

  def generate_footer
    bounding_box([0, footer_top], width: footer_width, height: FOOTER_HEIGHT) do
      footer_details
    end
  end

  def footer_details
    text "footer"
    transparent (0.5) { stroke_bounds }
  end

  def footer_top
    bounds.top - HEADER_HEIGHT - SECTION_MARGIN - body_height - SECTION_MARGIN
  end

  def footer_width
    bounds.right
  end

  def generate_body
    bounding_box([0, body_top], width: body_width, height: body_height) do
      body_details
    end
  end

  def body_details
    text "body"
    transparent (0.5) { stroke_bounds }
  end

  def body_top
    bounds.top - HEADER_HEIGHT - SECTION_MARGIN
  end

  def body_width
    bounds.right
  end

  def body_height
    bounds.top - HEADER_HEIGHT - FOOTER_HEIGHT - SECTION_MARGIN * 2
  end
end