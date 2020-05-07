class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_many :user_works
  has_many :works, through: :user_works
  has_many :user_tasks
  has_many :tasks, through: :user_tasks
  has_many :plans
  has_many :progress
  has_many :task_names, dependent: :destroy
  has_one :user_option, dependent: :destroy
  accepts_nested_attributes_for :user_option

  validates :name, presence: true
  # validates :email, presence: true, uniqueness: true
  # validates :password, presence: true
  # validates :password_confirmation, presence: true
  #上記3つはdeviseのデフォルトでバリデーションかけてくれている。
  #パスワードのバリデーションをかけると、実際に存在していないカラムなのでエラーがおきてしまう

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    result = update(params, *options)
    clean_up_passwords
    return result
  end
end
