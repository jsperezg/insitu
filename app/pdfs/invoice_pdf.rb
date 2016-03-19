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

    cell_invoice = header_cell("#{ Invoice.model_name.human }:", default_borders, default_padding)
    cell_invoice_number = data_cell(@invoice.number, default_borders, default_padding)

    cell_date = header_cell("#{ Invoice.human_attribute_name(:date) }:", default_borders, default_padding)
    cell_date_value = data_cell(I18n.l(@invoice[:date]), default_borders, default_padding)

    cell_payment_date = header_cell("#{ Invoice.human_attribute_name(:payment_date) }:", default_borders, default_padding)
    cell_payment_date_value = data_cell(I18n.l(@invoice[:payment_date]), default_borders, default_padding)

    t = make_table([
      [cell_invoice, cell_invoice_number],
      [cell_date, cell_date_value],
      [cell_payment_date, cell_payment_date_value ]
    ])

    t.draw
  end

  def footer_notes
    font DEFAULT_FONT, style: :normal
    font_size 10
    text Nokogiri::HTML(@invoice.payment_method.note_for_invoice).text
  end

  def footer_totals
    default_borders = []
    default_padding = [0, 5]

    totals = []

    totals << [
        header_cell("#{ Invoice.human_attribute_name :subtotal }:", [:top], default_padding, :right),
        data_cell("#{ number_with_precision(@invoice.subtotal, precision: 2) } €", [:top], default_padding, :right)
    ]

    if @invoice.discount > 0
      totals << [
          header_cell("#{ Invoice.human_attribute_name :discount }:", default_borders, default_padding, :right),
          data_cell("#{ number_with_precision(@invoice.discount, precision: 2) } €", default_borders, default_padding, :right)
      ]
    end

    if @invoice.irpf > 0
      totals << [
          header_cell("#{ Invoice.human_attribute_name :irpf } (#{ @invoice.irpf }%):", default_borders, default_padding, :right),
          data_cell("#{ number_with_precision(@invoice.applied_irpf, precision: 2) } €", default_borders, default_padding, :right)
      ]
    end

    @invoice.tax.each do |key, value|
      totals << [
          header_cell("#{ Invoice.human_attribute_name :tax } (#{ key }%):", default_borders, default_padding, :right),
          data_cell("#{ number_with_precision(value, precision: 2) } €", default_borders, default_padding, :right)
      ]
    end

    totals << [
        header_cell("#{ Invoice.human_attribute_name :total }:", default_borders, default_padding, :right),
        data_cell("#{ number_with_precision(@invoice.total, precision: 2) } €", default_borders, default_padding, :right)
    ]


    font DEFAULT_FONT, style: :normal
    font_size 10

    column_widths = [
        bounds.right * 60 / 100,
        bounds.right * 40 / 100,
    ]

    t = make_table(totals, column_widths: column_widths)
    t.draw
  end

  def body_details
    data_borders = []
    header_borders = [:bottom]
    header_padding = [0, 0]
    default_padding = [5, 0]

    details = []

    details << [
        header_cell(InvoiceDetail.human_attribute_name(:quantity), header_borders, header_padding),
        header_cell(InvoiceDetail.human_attribute_name(:description), header_borders, header_padding),
        header_cell(InvoiceDetail.human_attribute_name(:price), header_borders, header_padding, :right),
        header_cell(InvoiceDetail.human_attribute_name(:discount), header_borders, header_padding, :right),
        header_cell(InvoiceDetail.human_attribute_name(:vat_rate), header_borders, header_padding, :right),
        header_cell(InvoiceDetail.human_attribute_name(:total), header_borders, header_padding, :right)
    ]

    @invoice.invoice_details.each do |detail|
      description = detail.description
      description = detail.service.description if detail.description.blank?

      details << [
          data_cell("#{ detail.quantity }", data_borders, default_padding),
          data_cell(description, data_borders, default_padding),
          data_cell("#{ number_with_precision(detail.price, precision: 2)} €", data_borders, default_padding, :right),
          data_cell("#{ detail.discount} %", data_borders, default_padding, :right),
          data_cell("#{ detail.vat_rate } %", data_borders, default_padding, :right),
          data_cell("#{ number_with_precision(detail.subtotal, precision: 2) } €", data_borders, default_padding, :right)
      ]
    end

    column_widths = [
        body_width * 10 / 100,
        body_width * 45 / 100,
        body_width * 12 / 100,
        body_width * 10 / 100,
        body_width * 8 / 100,
        body_width * 15 / 100
    ]

    t = make_table(details, header: true, column_widths: column_widths)
    t.draw
  end
end