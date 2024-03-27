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

  ##################################
  # FUNCTION USER 
  ##################################
  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def industry_form_value
    industry.presence || "Industry not specified"
  end

  private

  def create_default_repertoire
    create_repertoire!
  end
  
end
