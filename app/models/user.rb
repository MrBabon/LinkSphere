class User < ApplicationRecord
  after_create :create_default_repertoire

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  ##################################
  # VALIDATES USER 
  ##################################      
  validates :first_name, presence: true, length: { maximum: 17 }, format: { without: /\s/ }
  validates :last_name, presence: true, length: { maximum: 20 }, format: { without: /\s/ }
  validates :phone, phone: { message: I18n.t('errors.messages.invalid_phone_number') }
  validates :biography, length: { maximum: 1000 }

  enum industry: {
    agriculture: "Agriculture",
    art_design: "Art & Design",
    education: "Education",
    energy: "Energy",
    engineering: "Engineering",
    environment: "Environment",
    finance: "Finance",
    health: "Healthcare",
    human_resources: "Human Resources",
    manufacturing: "Manufacturing",
    media: "Media",
    professional_services: "Professional Services",
    public_administration: "Public Administration",
    real_estate: "Real Estate",
    retail: "Retail",
    science: "Science",
    technology: "Technology",
    telecommunications: "Telecommunications",
    tourism: "Tourism",
    transportation: "Transportation",
  }

  validates :industry, inclusion: { in: industries.keys, message: "Industry invalid" }, allow_blank: true

  ##################################
  # ATTACHEMENT USER 
  ##################################
  # AVATAR
  has_one_attached :avatar

  # REPERTOIRE
  has_one :repertoire, dependent: :destroy

  # CHATROOM & MESSAGE
  has_many :messages, dependent: :destroy
  # USERS_CONTACT_GROUPS
  has_many :user_contact_groups
  has_many :contact_groups, through: :user_contact_groups

  # PARTICIPATION
  has_many :participations, dependent: :destroy
  has_many :participating_events, through: :participations, source: :event
  has_many :events, through: :participations

  # BLOCK
  has_many :blocks_given, foreign_key: :blocker_id, class_name: 'Block', dependent: :destroy
  has_many :blocked_users, through: :blocks_given, source: :blocked
  has_many :blocks_received, foreign_key: :blocked_id, class_name: 'Block', dependent: :destroy
  has_many :blockers, through: :blocks_received, source: :blocker

  # ENTREPRENEUR
  has_many :entrepreneurs, dependent: :destroy
  has_many :entreprises_as_owner, through: :entrepreneurs, source: :entreprise
  # EMPLOYEE
  has_many :employee_relationships, class_name: 'Employee', dependent: :destroy
  has_many :entreprises_as_employee, through: :employee_relationships, source: :entreprise

  #  PG SEARCH
  include PgSearch::Model
  pg_search_scope :search_by_name,
                  against: [:first_name, :last_name],
                  using: { tsearch: { prefix: true } }


  ##################################
  # FUNCTION USER 
  ##################################
  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def industry_form_value
    industry.presence || "Industry not specified"
  end

  def add_to_everyone_group
    everyone_group = ContactGroup.find_by(name: 'Everyone')
    UsersContactGroup.find_or_create_by(user: self, contact_group: everyone_group)
  end

  def chatrooms
    Chatroom.where("user1_id = ? OR user2_id = ?", self.id, self.id)
  end

  def entrepreneurs?
    entrepreneurs.exists?(user: self)
  end

  def employee_relationships?
    employee_relationships.exists?(user: self)
  end

  private

  def create_default_repertoire
    create_repertoire!
  end
  
end
