class Contact
  include Ocm::Ormable

  attr_accessor :email,
                :name,
                :company,
                :salesforce_id,
                :status,
                :action,
                :result
end

