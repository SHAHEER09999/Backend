class YoutubeService
  include HTTParty

  BASE_URL = "https://www.googleapis.com/youtube/v3"

  def self.verify(handle)
    api_key = Rails.application.credentials.youtube[:api_key]

    # Remove @ if user entered @channelname
    clean_handle = handle.to_s.delete_prefix("@")

    # Search for channel by handle/name
    search_response = get(
      "#{BASE_URL}/search",
      query: {
        part: "snippet",
        q: clean_handle,
        type: "channel",
        maxResults: 1,
        key: api_key
      }
    )

    items = search_response.parsed_response["items"]

    return { success: false, error: "YouTube channel not found" } if items.blank?

    channel_id = items.first.dig("id", "channelId")

     # Fetch statistics
    stats_response = get(
      "#{BASE_URL}/channels",
      query: {
        part: "statistics,snippet",
        id: channel_id,
        key: api_key
      }
    )

    channel = stats_response.parsed_response["items"]&.first

    return { success: false, error: "Unable to fetch channel data" } if channel.blank?

    {
      success: true,
      channel_id: channel_id,
      username: clean_handle,
      title: channel.dig("snippet", "title"),
      followers: channel.dig("statistics", "subscriberCount") || "0"
    }
  rescue StandardError => e
    {
      success: false,
      error: e.message
    }
  end
end