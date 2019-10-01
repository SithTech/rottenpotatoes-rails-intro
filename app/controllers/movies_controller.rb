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
    @all_ratings = Movie.all_valid_ratings
    @selected_ratings = params[:ratings]
    
    #Get movies with the selected ratings
    if @selected_ratings
      @movies = Movie.with_ratings(@selected_ratings.keys)
    else
      #If no movie ratings were selected, return all movies 
      @movies = Movie.with_ratings(@all_ratings.keys)
      @selected_ratings = @all_ratings
    end
    
    #Check if I need to sort by the title header
    if params[:title_header]
      @movies = Movie.order(title: :asc)
      #@movies = Movie.order(title: :desc)      #Left this here for future reference
    end
    
    #Check if I need to sort by the release date header
    if params[:release_date_header]
      @movies = Movie.order(release_date: :asc)
      #@movies = Movie.order(release_date: :desc)     #Left this here for future reference
    end
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
