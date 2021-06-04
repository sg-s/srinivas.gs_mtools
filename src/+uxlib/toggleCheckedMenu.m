% toggle a menu item 
function toggleCheckedMenu(src,~)

if strcmp(src.Checked,'on')
	src.Checked = 'off';
else
	src.Checked = 'on';
end