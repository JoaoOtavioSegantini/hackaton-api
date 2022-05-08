json.id consult.id 
json.started_at consult.started_at 
json.finish_at consult.finish_at 

json.payment_info consult.payment if consult.payment.present?

json.user consult.user if consult.user.present?
