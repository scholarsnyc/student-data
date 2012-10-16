module OmniauthInitializer
  def self.registered(app)
    app.use OmniAuth::Builder do
      provider :developer unless Padrino.env == :production
      provider :google, 'scholarsnyc.com', 'gbSiQxRCLg41RgQCTK4rOV+a'
    end

  end
end
