function pie_move( h, offset, r )
% pie_move( h, offset, r )
%
% given handles h of a pie plot, move it by offset (of the format [ x, y ]) and resize it by r.
%
% based on a solution by Walter Robinson. The original thread can be found here:
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/236342

if( ~exist( 'r', 'var' ) )
	r = 1;
end

x = offset( 1 );
y = offset( 2 );

for h_idx = 1:2:length( h )
	set( h( h_idx ), 'Vertices', bsxfun( @plus, get( h( h_idx ), 'Vertices' ) * r, [ x, y ] ) ); % move patches
	set( h( h_idx + 1 ), 'Position', get( h( h_idx + 1 ), 'Position' ) + [ x, y, 0 ] ); % move text
end


