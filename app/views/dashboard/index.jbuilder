json.past_year do
  json.partial! 'dashboard_element', period_data: @reports[:past_year]
end

json.current_year do
  json.partial! 'dashboard_element', period_data: @reports[:current_year]
end

json.current_month do
  json.partial! 'dashboard_element', period_data: @reports[:current_month]
end

json.last_year do
  json.partial! 'dashboard_element', period_data: @reports[:last_year]
end