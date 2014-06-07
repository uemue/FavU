class Tweet
  attr_reader :id, :reply_to, :text, :user, :favorited, :retweeted_by, :created_at

  def initialize(data)
    if data["retweeted_status"]
      fill_with_data(data["retweeted_status"])
      @retweeted_by = data["user"]
    else
      fill_with_data(data)
    end

    self
  end

  def fill_with_data(data)
    @id         = data["id_str"]
    @reply_to   = data["in_reply_to_status_id_str"]
    @text       = data["text"].unescape_tweet
    @user       = data["user"]
    @favorited  = data["favorited"]
    @created_at = data["created_at"]
  end

  def toggleFavorite
    if @favorited
      unfavorite
    else
      favorite
    end
  end

  def favorite
    client = STTwitterAPI.shared_client
    client.postFavoriteState(true,
              forStatusID: @id,
             successBlock: lambda{|status|},
               errorBlock: lambda{ |error|
                 UIAlertView.alert("Error", error.description)
               })

    @favorited = true
  end

  def unfavorite
    client = STTwitterAPI.shared_client
    client.postFavoriteState(false,
              forStatusID: @id,
             successBlock: lambda{|status|},
               errorBlock: lambda{ |error|
                 UIAlertView.alert("Error", error.description)
               })

    @favorited = false
  end
end