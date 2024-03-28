class Representative < ApplicationRecord
  belongs_to :exhibitor
  belongs_to :entreprise
  belongs_to :employee, class_name: 'User', foreign_key: 'employee_id', optional: true
  belongs_to :entrepreneur, class_name: 'User', foreign_key: 'entrepreneur_id', optional: true
end
