class Usuario < ApplicationRecord
  belongs_to :estado

  # Con este método encriptamos al password y generamos el método "authenticate"
  has_secure_password

  before_save :uppercase

  validates :login, :nombre, :nivel, :estado, :tipoImpresora, :usuariocre, presence: true #obligatorio
  validates :login, length: { maximum: 10, 
  message: "El nombre de usuario no puede ser mayor a 10 caracteres" }
  validates :password, length: { maximum: 15, 
  message: "La contraseña no puede ser mayor a 15 caracteres" }

  def generar_auth_token
      token = SecureRandom.hex
      self.update_columns(token: token)
      token
  end
  
  def invalidar_auth_token
      self.update_columns(token: nil)
  end

  def login_valido?(login, password)
      usuario1 = Usuario.find_by(login: login)
      if usuario1 && usuario1.authenticate(password)
          usuario1
      end
  end

  def admin?
      nivel == '1'
  end

  def validar_password(antiguaPassword, nuevaPassword)
      if self.authenticate(antiguaPassword)
          return true
      end
  end

  def uppercase
      self.nombre.upcase!
      self.login.downcase!
  end
end
