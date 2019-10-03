class Movie < ActiveRecord::Base
    
    #--------------------------------
    
    #Return all options for movie ratings
    def self.all_valid_ratings()
        #A Hash is used, instead of an Array, for the hash methods
        return {'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1', 'NC-17'=>'1'}
    end
    
    #--------------------------------
    
    #Return a set of movies that contain the given ratings
    def self.with_ratings(ratings)
        return self.where({rating: ratings})
    end
    
    #--------------------------------
end