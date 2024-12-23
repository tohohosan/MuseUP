Devise.setup do |config|
  # メール送信者の設定
  config.mailer_sender = ENV.fetch("MAILER_SENDER", "mock@example.com")

  # ORM設定
  require "devise/orm/active_record"

  # メールアドレス関連設定
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]

  # セッションストレージ設定
  config.skip_session_storage = [ :http_auth ]

  # パスワード設定
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # パスワードリセット設定
  config.reset_password_within = 6.hours

  # サインアウト設定
  config.sign_out_via = :delete

  # Google OAuth2 設定
  config.omniauth :google_oauth2,
                Rails.env.test? ? "mock_google_client_id" : Rails.application.credentials.google[:client_id],
                Rails.env.test? ? "mock_google_client_secret" : Rails.application.credentials.google[:client_secret],
                { scope: "userinfo.email,userinfo.profile" }

  # Twitter OAuth2 設定
  config.omniauth :twitter2,
                Rails.env.test? ? "mock_twitter_client_id" : Rails.application.credentials.twitter[:client_id],
                Rails.env.test? ? "mock_twitter_client_secret" : Rails.application.credentials.twitter[:client_secret],
                { scope: "tweet.read users.read offline.access" }

  # レスポンダー設定
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
