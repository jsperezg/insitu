class DeliveryNotePdf < DocumentPdf
  def initialize(current_user, delivery_note)
    @delivery_note = delivery_note

    super(current_user, delivery_note.customer)
  end

  def document_details
    default_borders = []
    default_padding = [0, 0]

    font DEFAULT_FONT, style: :bold
    font_size 24

    cell_invoice = header_cell("#{ DeliveryNote.model_name.human }", default_borders, default_padding)
    cell_invoice_number = header_cell(@delivery_note.number, default_borders, default_padding, :right)

    t = make_table([
       [cell_invoice, cell_invoice_number]
     ], { column_widths: [ header_width / 2, header_width / 2 ]})

    t.draw
  end

  def compose_document_conditions
    move_down 10

    indent(10) do
      column_title_width = (header_width - 10) / 4
      column_data_width = (header_width - 10) / 4
      default_borders = []
      default_padding = [0, 0]

      font DEFAULT_FONT, style: :normal
      font_size 12

      cell_date = header_cell("#{ DeliveryNote.human_attribute_name(:date) }:", default_borders, default_padding)
      cell_date_value = data_cell(I18n.l(@delivery_note[:date]), default_borders, default_padding)

      t = make_table([
         [cell_date, cell_date_value ]
       ], { column_widths: [ column_title_width, column_data_width ]})

      t.draw
    end
  end

  def footer_totals
    default_borders = [:top]
    default_padding = [0, 5]

    totals = []

    totals << [
        header_cell("#{ DeliveryNote.human_attribute_name :total }:", default_borders, default_padding, :right),
        data_cell("#{ number_with_precision @delivery_note.total, precision: 2 } #{ @current_user.currency }", default_borders, default_padding, :right)
    ]

    font DEFAULT_FONT, style: :normal
    font_size 10

    column_widths = [
        bounds.right * 60 / 100,
        bounds.right * 40 / 100,
    ]

    t = make_table(totals, column_widths: column_widths, cell_style: { size: 12 })
    t.draw
  end

  def body_details
    data_borders = []
    header_borders = [:bottom]
    header_padding = [0, 0]
    default_padding = [5, 0]

    details = []

    details << [
        header_cell(DeliveryNoteDetail.human_attribute_name(:quantity), header_borders, header_padding),
        header_cell(DeliveryNoteDetail.human_attribute_name(:service_id), header_borders, header_padding),
        header_cell(DeliveryNoteDetail.human_attribute_name(:price), header_borders, header_padding, :right),
        header_cell(DeliveryNoteDetail.human_attribute_name(:total), header_borders, header_padding, :right)
    ]

    @delivery_note.delivery_note_details.each do |detail|
      description = detail.custom_description
      description = detail.service.description if detail.custom_description.blank?

      details << [
          data_cell("#{ detail.quantity }", data_borders, default_padding),
          data_cell(description, data_borders, default_padding),
          data_cell("#{ number_with_precision(detail.price, precision: 2)} #{ @current_user.currency }", data_borders, default_padding, :right),
          data_cell("#{ number_with_precision(detail.total, precision: 2) } #{ @current_user.currency }", data_borders, default_padding, :right)
      ]
    end

    column_widths = [
        body_width * 10 / 100,
        body_width * 65 / 100,
        body_width * 10 / 100,
        body_width * 15 / 100
    ]

    t = make_table(details, header: true, column_widths: column_widths, cell_style: { size: 12 })
    t.draw
  end
end