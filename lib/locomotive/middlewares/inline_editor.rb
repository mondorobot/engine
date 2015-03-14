module Locomotive
  module Middlewares
    class InlineEditor

      def initialize(app, opts = {})
        @app = app
      end

      def call(env)
        status, headers, response = @app.call(env)

        response = modify(response) unless headers['Editable'].blank?

        [status, headers, response]
      end

      def modify(response)
        [].tap do |parts|
          response.each do |part|
            parts << part.to_s.gsub('</body>', %(
             <a  href="#{File.join(response.request.path, '/_admin')}" id="locomotive-inline-admin-button">Admin</a>
             </body>
             ))
          end
        end
      end

    end
  end
end