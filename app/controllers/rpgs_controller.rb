class RpgsController < ApplicationController
   def index
    if session[:gold] == nil
      session[:gold] = 0
    end

    if session[:messages] == nil
      session[:messages] = []
    end

    session[:total_golds] = session[:gold].to_i + session[:total_golds].to_i
    @total_golds = session[:total_golds]
    @current_date_time = Time.new
    @current_hour = @current_date_time.hour

    #this if statemtn formats date to 12 hour day and allows it to be displayed as 2016/9/18 12:59 pm 

    if(@current_hour > 11)
      @hour = @current_hour - 12

      if(@hour == 0)
        @date_time = "(#{@current_date_time.year}/#{@current_date_time.month}/#{@current_date_time.day} 12:#{@current_date_time.min} pm)"
      else
        @date_time = "(#{@current_date_time.year}/#{@current_date_time.month}/#{@current_date_time.day} #{@hour}:#{@current_date_time.min} pm)"
      end
    else
      @date_time = "(#{@current_date_time.year}/#{@current_date_time.month}/#{@current_date_time.day} #{@current_hour}:#{@current_date_time.min} am)"
    end

#only one case of losing gold is the casino 
    if session[:gold] < 0
      session[:messages] << "Entered a casino and lost #{session[:gold]*-1} golds... Time to walk away... #{@date_time}"
    #instead of writing all the statements, used hiddent inputs for building/gold params
    elsif session[:gold] > 0
      session[:messages] << "Earned #{session[:gold]} golds from the #{session[:building]}! #{@date_time}"
    end

    @activities = session[:messages]
  end

  def new
    if params[:building] == 'farm'
      session[:gold] = rand(10..20)
    elsif params[:building] == 'cave'
      session[:gold] = rand(5..10)
    elsif params[:building] == 'house'
      session[:gold] = rand(2..5)
    elsif params[:building] == 'casino'
      session[:gold] = rand(-50..50)
    end

    session[:building] = params[:building]

    redirect_to '' #redirects to index (localhost 3000)
  end

  def reset
    session.clear 
    redirect_to ''
  end 
end

