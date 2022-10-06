class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    #all ratings
    @all_ratings =Movie.all_ratings

    #filter ratings to match given template of checkboxes
    if !params[:sort_by].nil?
       session[:sort_by] = params[:sort_by]
    elsif !params[:ratings].nil?
       session[:ratings] = params[:ratings]
    end
    @ratings_to_show = session[:ratings] ? session[:ratings].keys : @all_ratings
    #redirect using session sorting if current params are empty
    if params[:ratings].nil?
       if !session[:ratings].nil?
           flash.keep
           redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
       end
    end
    #display movies whose ratings match ratings_to_show
    @movies = Movie.order(session[:sort_by]).where('rating IN (?)', @ratings_to_show)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
