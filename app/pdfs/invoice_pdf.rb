class InvoicePdf < DocumentPdf

  def initialize(current_user, invoice)
    @invoice = invoice

    super(current_user, invoice.customer)
  end

  def document_details
    default_borders = []
    default_padding = [0, 5]

    font DEFAULT_FONT, style: :normal
    font_size 10

    cell_invoice = make_cell(content: "#{ Invoice.model_name.human }:", borders: default_borders, padding: default_padding)
    cell_invoice.font_style = :bold

    cell_invoice_number = make_cell(content: @invoice.number, borders: default_borders, padding: default_padding)

    cell_date = make_cell(content: "#{ Invoice.human_attribute_name(:date) }:", borders: default_borders, padding: default_padding)
    cell_date.font_style = :bold

    cell_date_value = make_cell(content: I18n.l(@invoice[:date]), borders: default_borders, padding: default_padding)

    cell_payment_date = make_cell(content: "#{ Invoice.human_attribute_name(:payment_date) }:", borders: default_borders, padding: default_padding)
    cell_payment_date.font_style = :bold

    cell_payment_date_value = make_cell(content: I18n.l(@invoice[:payment_date]), borders: default_borders, padding: default_padding)

    t = make_table([
           [cell_invoice, cell_invoice_number],
           [cell_date, cell_date_value],
           [cell_payment_date, cell_payment_date_value ]
    ])

    t.draw
  end


end