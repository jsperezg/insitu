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
        header_cell("#{ Invoice.human_attribute_name :subtotal }:", default_borders, default_padding, :right),
        data_cell("#{ number_with_precision(@invoice.subtotal, precision: 2) } €", default_borders, default_padding, :right)
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

    totals << [
        header_cell("#{ Invoice.human_attribute_name :tax }:", default_borders, default_padding, :right),
        data_cell("#{ number_with_precision(@invoice.tax, precision: 2) } €", default_borders, default_padding, :right)
    ]

    totals << [
        header_cell("#{ Invoice.human_attribute_name :total }:", default_borders, default_padding, :right),
        data_cell("#{ number_with_precision(@invoice.total, precision: 2) } €", default_borders, default_padding, :right)
    ]


    font DEFAULT_FONT, style: :normal
    font_size 10

    t = make_table(totals)
    t.draw
  end




end