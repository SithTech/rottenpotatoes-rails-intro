class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #--------------------------------
    #For Debug Use Only
    #session.clear   
    #--------------------------------
    
    #Get a hash of all valid movie ratings from the database
    @all_ratings = Movie.all_valid_ratings
    
    #--------------------------------
   
    #Check for/apply filtered ratings
    if params[:ratings]
      session[:filter_ratings] = params[:ratings]
    else
      if !session[:filter_ratings]
        session[:filter_ratings] = @all_ratings
      end
    end
    
    #--------------------------------
    
    #Check for/apply sorted header
    if params[:filter_header]
      session[:filter_header] = params[:filter_header]
    end
    
    #--------------------------------
    
    #Update the checkboxes to be selected
    @selected_ratings = session[:filter_ratings]
    
    #--------------------------------
    
    #Fetch the appropriate movies from the database
    @movies = (Movie.order(session[:filter_header])).with_ratings(session[:filter_ratings].keys)
    
    #--------------------------------
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
