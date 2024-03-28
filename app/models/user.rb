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
  validates :phone, presence: true, length: { maximum: 20 }
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
  has_many :users_contact_groups
  has_many :contact_groups, through: :users_contact_groups

  # BLOCK
  has_many :blocks_given, foreign_key: :blocker_id, class_name: 'Block', dependent: :destroy
  has_many :blocked_users, through: :blocks_given, source: :blocked
  has_many :blocks_received, foreign_key: :blocked_id, class_name: 'Block', dependent: :destroy
  has_many :blockers, through: :blocks_received, source: :blocker

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

  private

  def create_default_repertoire
    create_repertoire!
  end
  
end
