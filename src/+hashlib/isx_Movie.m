function H = isx_Movie(movie)

arguments
	movie (1,1) isx.Movie
end

% speed it up by reading just the first and last frame and hashing that
frame = movie.get_frame_data(0);

Ha = hashlib.md5hash(frame);

frame = movie.get_frame_data(movie.timing.num_samples-1);
Hz = hashlib.md5hash(frame);

H = hashlib.hash([Ha Hz]);