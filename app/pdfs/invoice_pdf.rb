class InvoicePdf < DocumentPdf

  def initialize(current_user, invoice)
    super(current_user, invoice.customer)

    @invoice = invoice

    generate_header
    generate_body
    generate_footer
  end

  def generate_body
    bounding_box([0, body_top], width: body_width, height: body_height) do
      text "body"
      transparent (0.5) { stroke_bounds }
    end
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