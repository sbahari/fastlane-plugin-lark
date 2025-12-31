require 'fastlane/action'
require_relative '../helper/lark_helper'

module Fastlane
  module Actions
    class LarkAction < Action
      def self.run(params)
        require 'json'
        require 'net/http'
        require 'openssl'
        require 'base64'

        message = params[:message]
        webhook_url = params[:webhook_url]
        secret = params[:signature]
        timestamp = Time.now.to_i

        payload = {
          msg_type: "text",
          content: {
            text: message
          }
        }

        if secret && !secret.empty?
          payload[:timestamp] = timestamp.to_s
          payload[:sign] = self.generate_signature(secret, timestamp)
        end

        uri = URI.parse(webhook_url)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
        request.body = payload.to_json

        response = https.request(request)

        if response.code == "200"
          UI.success("Successfully sent notification to Lark")
        else
          UI.error("Failed to send notification to Lark: #{response.code} - #{response.body}")
        end
      end

      def self.generate_signature(secret, timestamp)
        string_to_sign = "#{timestamp}\n#{secret}"
        digest = OpenSSL::Digest.new('sha256')
        hmac = OpenSSL::HMAC.digest(digest, string_to_sign, "")
        Base64.strict_encode64(hmac)
      end

      def self.description
        "Fastlane plugin to send webhook notification to lark"
      end

      def self.authors
        ["sbahari"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Fastlane plugin to send webhook notification to lark"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :message,
                                 env_name: "LARK_MESSAGE",
                              description: "The message to send to Lark",
                                 optional: false,
                                     type: String),
          FastlaneCore::ConfigItem.new(key: :webhook_url,
                                 env_name: "LARK_WEBHOOK_URL",
                              description: "The Lark webhook URL",
                                 optional: false,
                                     type: String),
          FastlaneCore::ConfigItem.new(key: :signature,
                                 env_name: "LARK_SIGNATURE",
                              description: "The Lark webhook signature (secret key)",
                                 optional: true,
                                     type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
