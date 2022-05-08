json.rents do
    json.array! @loading_service.records
  end

  json.meta do
    json.partial! 'shared/pagination', pagination: @loading_service.pagination
 end