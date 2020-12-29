require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Projects
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # 不要なスペックを作成しない。
    config.generators do |g| 
      g.test_framework :rspec,
      # テストデータベースにレコードを作成するファイルの作成をスキップ
      fixtures: false,
      # ビュースペックを作成しない。代わりに フィーチャスペック で UI をテストします。
      view_specs: false,
      # ヘルパーファイル用のスペックを作成しない
      helper_specs: false,
      # config/routes.rb 用のスペックファイルの作成を省略
      # しかし、アプリケーションが大きくなってルーティングが複雑になってきたら、
      # ルーティングスペックを導入するのは良い考えです。
      routing_specs: false
    end
  end
end
