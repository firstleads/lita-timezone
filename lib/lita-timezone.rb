require 'active_support'
require 'active_support/core_ext/time'
require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require 'lita/handlers/timezone'

Lita::Handlers::Timezone.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
