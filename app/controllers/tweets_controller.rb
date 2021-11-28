class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[ show edit update destroy ]

  TWEETS_PER_PAGE = 50

  # GET /tweets or /tweets.json
  def index
    @page = params.fetch(:page, 0).to_i
    @pages = (Tweet.all.count / TWEETS_PER_PAGE.to_f).ceil
    @tweets = Tweet.offset(@page * TWEETS_PER_PAGE).limit(TWEETS_PER_PAGE)
  end

  # GET /tweets/1 or /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    if not params[:retweet_id].nil?
      @tweet = Tweet.new(retweet_id: params[:retweet_id])
    else
      @tweet = Tweet.new
    end
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  def create
    @tweet = Tweet.new(tweet_params)
    
    if @tweet.save
      redirect_to @tweet, notice: "Tweet was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      redirect_to @tweet, notice: "Tweet was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/1
  def destroy
    @tweet.destroy
    redirect_to tweets_url, notice: "Tweet was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content, :retweet_id).merge(user: current_user)
    end
end
