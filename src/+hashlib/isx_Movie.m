function H = isx_Movie(movie)

arguments
	movie (1,1) isx.Movie
end

H = hashlib.md5hash(movie.file_path,'file');