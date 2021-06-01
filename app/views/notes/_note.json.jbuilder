json.extract! note, :id, :user_id, :title, :description, :created_at, :updated_at
json.url note_url(note, format: :json)
